const express = require("express");
import crypto from 'crypto';
import nodemailer, { Transporter } from 'nodemailer';
import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import { passwordHash } from '../strategies/passwordHash';
import pool from "../pool";

//Types
import { NextFunction, Request, Response } from "express";
import { UserType } from '../types/UserType';

interface AuthInfo {
    message?: string
}

interface EmailOptions {
    from: string;
    to: string;
    subject: string;
    text: string;
}


const passportConfig = require('../strategies/passportConfig');
const router = express.Router();

// Find a user by username
export const findUserByUsername = async (username: string) => {
    console.log('Find user by email called');
    const result = await pool.query(
        'SELECT * FROM "user" WHERE username = $1',
        [username]
    );
    return result.rows[0];
};

// Update user password
export const updateUserPassword = async (email: string, password: string) => {
    await pool.query(
        'UPDATE "user" SET password = $1, reset_password_token = NULL, reset_password_expires = NULL WHERE username = $2',
        [password, email]
    );
};

//Cookie testing route - do not use
router.get('/set-cookie', (req: Request, res: Response) => {
    res.cookie('test', 'testValue', {
        httpOnly: true,
        secure: false,
        sameSite: 'lax',
    });
    res.send('Cookie')
})

router.get('/authenticate', (req: Request, res: Response) => {
    if (req.isAuthenticated()) {
        const { password, ...safeUser } = req.user as any; // Exclude the password
        console.log('Authenticated User:', safeUser);
        return res.status(200).json(safeUser); // Send the filtered object
    }

    res.status(401).json({ message: 'User not authenticated' });
});


router.post('/login', (req: Request, res: Response, next: NextFunction) => {
    passportConfig.authenticate('local', (err: Error, user: UserType, info: AuthInfo) => {
        if (err) {
            // Handle server errors
            return res.status(500).json({ message: 'An error occurred during authentication' });
        }
        if (!user) {
            // Handle authentication failure and send the message from `info`
            return res.status(401).json({ message: info?.message || 'Login failed' });
        }
        // If authentication is successful, log the user in
        req.logIn(user, (loginErr) => {
            if (loginErr) {
                return res.status(500).json({ message: 'Login failed' });
            }
            return res.status(200).send({ message: 'Logged in successfully', id: user.id, username: user.username });
        });
    })(req, res, next);

});

router.post('/register', async (req: Request, res: Response, next: NextFunction) => {
    console.log('/user/register called');
    console.log('*************Database URL env *****************', process.env.DATABASE_URL);
    try {
        const { username, password: plainPassword } = req.body;

        // Hash the password asynchronously
        const password = await passwordHash(plainPassword);

        // Step 1: Check if the username already exists
        const checkUserQuery = 'SELECT id FROM "user" WHERE username = $1';
        const checkUserResult = await pool.query<{ id: number }>(checkUserQuery, [username]);

        if (checkUserResult.rowCount! > 0) {
            // Username already exists
            return res.status(409).send('Username already taken'); // 409 Conflict
        }

        // Step 2: Insert the new user
        const insertUserQuery =
            `INSERT INTO "user" (username, password) VALUES ($1, $2) RETURNING id;`;
        const insertUserResult = await pool.query<{ id: number }>(insertUserQuery, [username, password]);

        // Send a success response with the new user's ID
        res.status(201).json({ id: insertUserResult.rows[0].id });
    } catch (error) {
        console.error('User registration failed:', error);
        res.sendStatus(500); // Internal Server Error
    }
});

// Forgot Password Route
router.post('/forgot-password', async (req: Request, res: Response) => {
    const serverURL = process.env.SERVER_URL;
    const { username } = req.body;

    try {
        console.log(username);
        const user = await findUserByUsername(username);
        if (!user) {
            console.log('User not found');
            return res.status(404).send('User with this email does not exist');
        } else if (user.is_removed) {
            return res.status(403).send('User has been removed');
        }

        const token = crypto.randomBytes(32).toString('hex');
        await pool.query(
            `UPDATE "user" SET reset_password_token = $1, reset_password_expires = $2 WHERE username = $3;`
            ,
            [token, new Date(Date.now() + 3600000), username]
        );

        const transporter: Transporter = nodemailer.createTransport({
            host: process.env.MAILTRAP_HOST,
            port: process.env.MAILTRA_PORT,
            secure: false,
            auth: {
                user: process.env.MAILTRAP_USERNAME,
                pass: process.env.MAILTRAP_PASSWORD
            }
        } as nodemailer.TransportOptions);

        const resetLink = `${process.env.FRONTEND_URL}/reset-password/?token=${token}`;
        await transporter.sendMail({
            to: username,
            from: 'tinkl web application@trans.com',
            subject: 'Password Reset',
            text: `You requested a password reset. Click the following link to reset your password: ${resetLink}`,
        });

        res.json('Password reset email sent');
    } catch (error) {
        console.error(error);
        res.status(500).send('Server error');
    }
});

// Reset Password Route
router.post('/reset-password/:token', async (req: Request, res: Response) => {

    const { token } = req.params;
    const { password } = req.body;
    console.log('Reset Password route called', token, ' ', password);

    try {
        const result = await pool.query(
            'SELECT * FROM "user" WHERE reset_password_token = $1 AND reset_password_expires > $2',
            [token, new Date()]
        );

        const user = result.rows[0];
        if (!user) {
            console.log('Invalid');
            return res.status(400).send('Invalid or expired token');
        }

        const hashedPassword = await passwordHash(password);
        await updateUserPassword(user.username, hashedPassword);

        res.send('Password has been reset successfully');
    } catch (error) {
        console.log(error);
        res.status(500).send('Server error');
    }
});

router.post('/logout', (req: Request, res: Response) => {
    req.logout((err) => {
        if (err) {
            return res.status(500).json({ message: "Error logging out", error: err });
        }

        req.session.destroy((err) => {
            if (err) {
                return res.status(500).json({ message: "Error destroying session", error: err });
            }
            res.clearCookie('connect.sid');

            res.status(200).json({ message: 'Logged out successfully' });
        });
    });
});

module.exports = router;
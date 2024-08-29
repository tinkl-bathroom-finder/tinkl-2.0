const express = require("express");
import crypto from 'crypto';
import nodemailer from 'nodemailer';
import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import { passwordHash } from '../strategies/passwordHash';

//Types
import { NextFunction, Request, Response } from "express";
import pool from "../pool";

const passportConfig = require('../strategies/passportConfig');


const router = express.Router();

export const findUserByEmail = async (email: string) => {
    const result = await pool.query(
        'SELECT * FROM user WHERE email = $1',
        [email]
    );
    return result.rows[0];
};

// Find a user by username
export const findUserByUsername = async (username: string) => {
    const result = await pool.query(
        'SELECT * FROM user WHERE username = $1',
        [username]
    );
    return result.rows[0];
};

// Update user password
export const updateUserPassword = async (email: string, password: string) => {
    await pool.query(
        'UPDATE user SET password = $1, reset_password_token = NULL, reset_password_expires = NULL WHERE email = $2',
        [password, email]
    );
};

router.get('/', rejectUnauthenticated, (req: Request, res: Response) => {
    // Send back user object from the session (previously queried from the database)
    res.send(req.user);
});

router.post('/login', passportConfig.authenticate('local'), (req: Request, res: Response) => {
    res.sendStatus(200);
});

router.post('/register', async (req: Request, res: Response, next: NextFunction) => {
    console.log('/user/register called');
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
        const insertUserQuery = `INSERT INTO "user" (username, password) VALUES ($1, $2) RETURNING id`;
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
    const { email } = req.body;

    try {
        const user = await findUserByEmail(email);
        if (!user) {
            return res.status(400).send('User with this email does not exist');
        }

        const token = crypto.randomBytes(32).toString('hex');
        await pool.query(
            'UPDATE users SET reset_password_token = $1, reset_password_expires = $2 WHERE email = $3',
            [token, new Date(Date.now() + 3600000), email]
        );

        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
                user: process.env.EMAIL_USER!,
                pass: process.env.EMAIL_PASS!,
            },
        });

        const resetLink = `http://localhost:3000/reset-password/${token}`;
        await transporter.sendMail({
            to: email,
            from: process.env.EMAIL_USER!,
            subject: 'Password Reset',
            text: `You requested a password reset. Click the following link to reset your password: ${resetLink}`,
        });

        res.send('Password reset email sent');
    } catch (error) {
        res.status(500).send('Server error');
    }
});

// Reset Password Route
router.post('/reset-password/:token', async (req: Request, res: Response) => {
    const { token } = req.params;
    const { password } = req.body;

    try {
        const result = await pool.query(
            'SELECT * FROM users WHERE reset_password_token = $1 AND reset_password_expires > $2',
            [token, new Date()]
        );

        const user = result.rows[0];
        if (!user) {
            return res.status(400).send('Invalid or expired token');
        }

        const hashedPassword = await passwordHash(password);
        await updateUserPassword(user.email, hashedPassword);

        res.send('Password has been reset successfully');
    } catch (error) {
        res.status(500).send('Server error');
    }
});

module.exports = router;
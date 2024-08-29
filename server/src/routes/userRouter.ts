const express = require("express");
import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import { passwordHash } from '../strategies/passwordHash';

//Types
import { NextFunction, Request, Response } from "express";
import pool from "../pool";

const passportConfig = require('../strategies/passportConfig');


const router = express.Router();

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

module.exports = router;
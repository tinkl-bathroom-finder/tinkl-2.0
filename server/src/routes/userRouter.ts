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
    try {
        const username = req.body.username;
        const password = await passwordHash(req.body.password)

        const queryText = `INSERT INTO "user" (username, password)
        VALUES ($1, $2) RETURNING id`;
        await pool.query(queryText, [username, password]);
        res.sendStatus(201)
    } catch (error) {
        console.log('User registration failed: ', error);
        res.sendStatus(500);
    }
});

module.exports = router;
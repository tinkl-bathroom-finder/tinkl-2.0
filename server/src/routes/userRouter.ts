const express = require("express");
import { passwordHash } from '../strategies/passwordHash';

//Types
import { NextFunction, Request, Response } from "express";
import pool from "../pool";

const passportConfig = require('../strategies/passportConfig');


const router = express.Router();

router.get('/login', passportConfig.authenticate('local'), (req: Request, res: Response) => {
    console.log('Login Call made', req.user);
    res.sendStatus(200);
});

router.post('/register', (req: Request, res: Response, next: NextFunction) => {
    const username = req.body.username;
    const password = passwordHash(req.body.password)

    const queryText = `INSERT INTO "user" (username, password)
    VALUES ($1, $2) RETURNING id`;
    pool
        .query(queryText, [username, password])
        .then(() => res.sendStatus(201))
        .catch((err) => {
            console.log('User registration failed: ', err);
            res.sendStatus(500);
        });
});

module.exports = router;
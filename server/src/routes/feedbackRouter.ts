//Types
import { Request, Response } from "express";
import { QueryResult } from 'pg';
import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import pool from "../pool";
const express = require("express");

const router = express.Router();

// POST route for feedback&comments

router.post('/', rejectUnauthenticated, async (req: Request, res: Response) => {
    const connection = await pool.connect();
    try {
        await connection.query('BEGIN;')

        // adds upvote/downvote
        const voteQuery = `
        INSERT INTO "restroom_votes"
            ("upvote", "downvote", "restroom_id", "user_id")
            VALUES
            ($1, $2, $3, $4);
            `;
        const voteValues = [
            req.body.upvote,
            req.body.downvote,
            req.body.restroom_id,
            req.body.user_id
        ];
        await pool.query(voteQuery, voteValues)

        // if there is a comment, posts comment
        if (req.body.comment.length) {
            const commentQuery = `
                INSERT INTO "comments"
                    ("content", "restroom_id", "user_id")
                    VALUES
                    ($1, $2, $3);
                `;
            const commentValues = [
                req.body.comment,
                req.body.restroom_id,
                req.body.user_id
            ];
            await pool.query(commentQuery, commentValues)
        }

        await connection.query('COMMIT;');
        res.sendStatus(201)
    } catch (error) {
        console.log('Error in /feedback post route:', error)
        await connection.query('ROLLBACK;');
        res.sendStatus(500);
    } finally {
        connection.release()
    }
})

module.exports = router;
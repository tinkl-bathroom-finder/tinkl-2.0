import pool from "../pool";
const express = require("express");
import { rejectUnauthenticated } from '../strategies/authenticationPassport';

//Types
import { Request, Response } from "express";
import {
    LikeBathroomType,
    PostCommentType,
    DeleteCommentType,
    BookmarkType
} from '../types/FeedbackTypes';

const router = express.Router();

// LIKE / DISLIKE ROUTE
router.post('/like', rejectUnauthenticated, async (req: Request<LikeBathroomType>, res: Response) => {
    console.log('api/feedback/like route called', req.body);

    const { user_id, bathroom_id, vote } = req.body;

    try {
        // Step 1: Check if the user has an existing vote
        const checkVoteQuery = `
            SELECT * 
            FROM restroom_votes
            WHERE user_id = $1 AND restroom_id = $2;
        `;
        const checkVoteValues = [user_id, bathroom_id];
        const { rows } = await pool.query(checkVoteQuery, checkVoteValues);

        if (rows.length === 0) {
            // Step 2: Insert a new vote if no existing vote
            const insertVoteQuery = `
                INSERT INTO restroom_votes (user_id, restroom_id, upvote, downvote)
                VALUES ($1, $2, 
                        CASE WHEN $3 = 'upvote' THEN 1 ELSE 0 END, 
                        CASE WHEN $3 = 'downvote' THEN 1 ELSE 0 END);
            `;
            const insertVoteValues = [user_id, bathroom_id, vote];
            await pool.query(insertVoteQuery, insertVoteValues);
        } else {
            const existingVote = rows[0];

            if ((existingVote.upvote === 1 && vote === 'upvote') || (existingVote.downvote === 1 && vote === 'downvote')) {
                // Step 3: Delete the vote if the user selected the same option
                const deleteVoteQuery = `
                    DELETE FROM restroom_votes
                    WHERE user_id = $1 AND restroom_id = $2;
                `;
                const deleteVoteValues = [user_id, bathroom_id];
                await pool.query(deleteVoteQuery, deleteVoteValues);
            } else {
                // Step 4: Update the vote if the user changed their choice
                const updateVoteQuery = `
                    UPDATE restroom_votes
                    SET upvote = CASE WHEN $3 = 'upvote' THEN 1 ELSE 0 END,
                        downvote = CASE WHEN $3 = 'downvote' THEN 1 ELSE 0 END,
                        updated_at = NOW()
                    WHERE user_id = $1 AND restroom_id = $2;
                `;
                const updateVoteValues = [user_id, bathroom_id, vote];
                await pool.query(updateVoteQuery, updateVoteValues);
            }
        }

        res.sendStatus(201); // Success
    } catch (error) {
        console.error('/feedback/like POST route failed:', error);
        res.sendStatus(500); // Server error
    }
});

// COMMENT ROUTES
router.post('/comment', rejectUnauthenticated, (req: Request<PostCommentType>, res: Response) => {
    const addCommentQuery = `
        INSERT INTO "comments"
        ("content", "restroom_id", "user_id")
    VALUES
        ($1, $2, $3);
    `
    const addCommentValues = [
        req.body.comment,
        req.body.restroom_id,
        req.body.user_id
    ]
    pool
        .query(addCommentQuery, addCommentValues)
        .then(() => {
            res.sendStatus(201)
        })
        .catch((error) => {
            console.log('/feedback/comment POST route failed:', error)
            res.sendStatus(500)
        })
})
router.delete('/comment', rejectUnauthenticated, (req: Request<DeleteCommentType>, res: Response) => {
    const deleteCommentQuery = `
        DELETE FROM "comments" WHERE "user_id" = $1 AND "id" = $2;
    `
    const deleteCommentValues = [
        req.body.user_id,
        req.body.id
    ]
    pool
        .query(deleteCommentQuery, deleteCommentValues)
        .then(() => {
            res.sendStatus(200)
        })
        .catch((error) => {
            console.log('/feedback/comment DELETE route failed:', error)
            res.sendStatus(500)
        })
})

// BOOKMARK ROUTES
router.post('/bookmark', rejectUnauthenticated, (req: Request<BookmarkType>, res: Response) => {
    const newBookmarkQuery = `
        INSERT INTO "bookmarks"(user_id, restroom_id)
    VALUES($1, $2);
    `
    const newBookmarkValues = [
        req.body.user_id,
        req.body.restroom_id
    ]
    pool.query(newBookmarkQuery, newBookmarkValues)
        .then(() => {
            res.sendStatus(201)
        })
        .catch((error) => {
            console.error('/feedback/bookmark POST route failed:', error)
            res.sendStatus(500)
        })
})
router.delete('/bookmark', rejectUnauthenticated, (req: Request<BookmarkType>, res: Response) => {
    const deleteBookmarkQuery = `
        DELETE FROM "bookmarks" WHERE "user_id" = $1 AND "restroom_id" = $2
        `
    const deleteBookmarkValues = [
        req.body.user_id,
        req.body.restroom_id
    ]
    pool.query(deleteBookmarkQuery, deleteBookmarkValues)
        .then(() => {
            res.sendStatus(201)
        })
        .catch((error) => {
            console.error('/feedback/bookmark DELETE route failed:', error)
            res.sendStatus(500)
        })
})

module.exports = router;

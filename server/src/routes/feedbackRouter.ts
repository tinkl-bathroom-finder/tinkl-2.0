import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import pool from "../pool";
const express = require("express");

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
router.post('/like', rejectUnauthenticated, (req: Request<LikeBathroomType>, res: Response) => {
    const likeQuery = `
        DO $$
        DECLARE
            existing_vote RECORD;
        BEGIN
            -- Check if the user has already voted for the restroom
            SELECT * INTO existing_vote
            FROM restroom_votes
            WHERE user_id = $1 AND restroom_id = $2;

            IF NOT FOUND THEN
                -- User has not voted yet, insert the new vote (upvote or downvote)
                INSERT INTO restroom_votes (user_id, restroom_id, upvote, downvote)
                VALUES ($1, $2, 
                    CASE WHEN $3 = 'upvote' THEN 1 ELSE 0 END, 
                    CASE WHEN $3 = 'downvote' THEN 1 ELSE 0 END, 
                    );
            ELSIF existing_vote.upvote = 1 AND $3 = 'upvote' THEN
                -- User previously upvoted and selects the same, delete the vote
                DELETE FROM restroom_votes
                WHERE user_id = $1 AND restroom_id = $2;
            ELSIF existing_vote.downvote = 1 AND $3 = 'downvote' THEN
                -- User previously downvoted and selects the same, delete the vote
                DELETE FROM restroom_votes
                WHERE user_id = $1 AND restroom_id = $2;
            ELSE
                -- User previously voted the opposite, update the vote
                UPDATE restroom_votes
                SET upvote = CASE WHEN $3 = 'upvote' THEN 1 ELSE 0 END,
                    downvote = CASE WHEN $3 = 'downvote' THEN 1 ELSE 0 END,
                    updated_at = NOW()
                WHERE user_id = $1 AND restroom_id = $2;
            END IF;
        END $$;
    `
    const likeValues = [
        req.body.user_id,
        req.body.restroom_id,
        req.body.vote
    ]
    pool.query(likeQuery, likeValues)
        .then(() => {
            res.sendStatus(201)
        })
        .catch((error) => {
            console.log('/feedback/like POST route failed:', error)
            res.sendStatus(500)
        })
})

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
        INSERT INTO "bookmarks" (user_id, restroom_id)
        VALUES ($1, $2);
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

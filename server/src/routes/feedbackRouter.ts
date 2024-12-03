import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import pool from "../pool";
const express = require("express");

//Types
import { Request, Response } from "express";
import { PostCommentType, DeleteCommentType } from '../types/FeedbackTypes';

const router = express.Router();


// likes route
router.post('/like', rejectUnauthenticated, (req: Request, res: Response) => {

})

// comment routes
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
        DELETE FROM "comments" WHERE "user_id" = $1 AND "id" = $2
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

// router.post('/', rejectUnauthenticated, async (req: Request, res: Response) => {
//     const connection = await pool.connect()
//     try {
//         await connection.query('BEGIN;')

//         // adds upvote/downvote
//         const voteQuery = `
//         INSERT INTO "restroom_votes"
//             ("upvote", "downvote", "restroom_id", "user_id")
//             VALUES
//             ($1, $2, $3, $4);
//             `;
//         const voteValues = [
//             req.body.upvote,
//             req.body.downvote,
//             req.body.restroom_id,
//             req.body.user_id
//         ];
//         await pool.query(voteQuery, voteValues)

//         // if there is a comment, posts comment
//         if (req.body.comment.length) {
//             const commentQuery = `
//                 INSERT INTO "comments"
//                     ("content", "restroom_id", "user_id")
//                     VALUES
//                     ($1, $2, $3);
//                 `;
//             const commentValues = [
//                 req.body.comment,
//                 req.body.restroom_id,
//                 req.body.user_id
//             ];
//             await pool.query(commentQuery, commentValues)
//         }

//         await connection.query('COMMIT;');
//         res.sendStatus(201)
//     } catch (error) {
//         console.log('Error in /feedback post route:', error)
//         await connection.query('ROLLBACK;');
//         res.sendStatus(500);
//     } finally {
//         connection.release()
//     }
// })

module.exports = router;

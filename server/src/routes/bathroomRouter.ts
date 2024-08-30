//Types
import { Request, Response } from "express";
import { QueryResult } from 'pg';
import pool from "../pool";
const express = require("express");

const router = express.Router();

router.get('/getAllBathrooms', (req: Request, res: Response) => {
    const query = /*sql*/ `
  SELECT 
  "restrooms".*,
   "opening_hours".weekday_text,
   "opening_hours".day_0_open,
   "opening_hours".day_0_close,
   "opening_hours".day_1_open,
   "opening_hours".day_1_close,
   "opening_hours".day_2_open,
   "opening_hours".day_2_close,
   "opening_hours".day_3_open,
   "opening_hours".day_3_close,
   "opening_hours".day_4_open,
   "opening_hours".day_4_close,
   "opening_hours".day_5_open,
   "opening_hours".day_5_close,
   "opening_hours".day_6_open,
   "opening_hours".day_6_close,
  SUM("restroom_votes".upvote) AS "upvotes", 
  SUM ("restroom_votes".downvote) AS "downvotes"
FROM "restrooms"
LEFT JOIN "restroom_votes" ON "restrooms".id="restroom_votes".restroom_id
LEFT JOIN "opening_hours" ON "restrooms".id="opening_hours".restroom_id
WHERE "restrooms".is_removed = FALSE
GROUP BY "restrooms".id, "opening_hours".weekday_text,
   "opening_hours".day_0_open,
   "opening_hours".day_0_close,
   "opening_hours".day_1_open,
   "opening_hours".day_1_close,
   "opening_hours".day_2_open,
   "opening_hours".day_2_close,
   "opening_hours".day_3_open,
   "opening_hours".day_3_close,
   "opening_hours".day_4_open,
   "opening_hours".day_4_close,
   "opening_hours".day_5_open,
   "opening_hours".day_5_close,
   "opening_hours".day_6_open,
   "opening_hours".day_6_close;`;

    pool.query(query)
        .then((response: QueryResult) => {
            // console.log("dbRes.rows in GET /all route:", dbRes);
            res.send(response.rows);
            console.log('Response*****************************************');
            // console.log(response.rows);
        })
        .catch((error: Error) => {
            console.log("fail:", error);
            res.sendStatus(500);
        });
});

module.exports = router;
import pool from "../pool";
const express = require("express");

//Types
import { Request, Response } from "express";

const router = express.Router();


//Using this route requires installation of postgis
//on a mac: brew install postgis
router.get('/getBathroomsByRadius', async (req: Request, res: Response) => {
  const { latitude, longitude, radius, localISOTime } = req.query;

  console.log('/getBathroomsByRadius', latitude, longitude, radius, localISOTime)

  if (!latitude || !longitude || !radius || !localISOTime) {
    return res.status(400).json({ error: "Missing required query parameters: latitude, longitude, radius & localISOTime" })
  }

  try {
    const query =
      `--sql
      WITH formatted_hours AS (      
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
          COALESCE("votes_query"."upvotes", 0) AS "upvotes", 
          COALESCE("votes_query"."downvotes", 0) AS "downvotes",
          COALESCE("comments_query"."comments", '[]'::json) AS "comments",
           -- Convert integer hours to text, pad them to 4 digits, and then convert to TIME
        TO_TIMESTAMP(LPAD(opening_hours.day_0_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_0_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_0_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_0_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_1_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_1_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_1_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_1_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_2_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_2_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_2_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_2_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_3_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_3_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_3_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_3_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_4_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_4_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_4_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_4_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_5_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_5_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_5_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_5_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_6_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_6_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_6_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_6_close
            FROM "restrooms"
      
            LEFT JOIN (
                  SELECT 
                    "restroom_id", 
                    SUM("upvote") AS "upvotes",
                    SUM("downvote") AS "downvotes"
                  FROM "restroom_votes"
                  GROUP BY "restroom_id"
                ) 
                AS "votes_query" ON "restrooms"."id" = "votes_query"."restroom_id"
            
            LEFT JOIN (
                  SELECT 
                    "restroom_id",
                    json_agg(
                      json_build_object(
                        'id', comments.id,
                        'content', comments.content,
                        'user_id', comments.user_id,
                        'inserted_at', comments.inserted_at
                      )
                      order by "inserted_at" DESC
                    ) 
                    AS "comments"
                      FROM "comments"
                      WHERE "comments"."is_removed" = FALSE
                      GROUP BY "comments"."restroom_id"
                      ) 
                      AS "comments_query" ON "restrooms"."id" = "comments_query"."restroom_id"
                      
            LEFT JOIN "opening_hours" ON "restrooms".id="opening_hours".restroom_id)
            
      SELECT
          formatted_hours.*,
          -- Calculate the distance in miles
          ST_Distance(
              ST_MakePoint($1, $2)::geography,
              ST_MakePoint(formatted_hours.longitude, formatted_hours.latitude)::geography
          ) * 0.000621371 AS distance_in_miles,
          CASE
              -- Check if the current day is Sunday (day 0) based on the user's local time
              WHEN EXTRACT(DOW FROM $4::timestamp) = 0
                  AND (formatted_hours.day_0_open IS NULL OR formatted_hours.day_0_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_0_open AND formatted_day_0_close)
              THEN true
              -- Check if the current day is Monday (day 1)
              WHEN EXTRACT(DOW FROM $4::timestamp) = 1
                  AND (formatted_hours.day_1_open IS NULL OR formatted_hours.day_1_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_1_open AND formatted_day_1_close)
              THEN true
              -- Check if the current day is Tuesday (day 2)
              WHEN EXTRACT(DOW FROM $4::timestamp) = 2
                  AND (formatted_hours.day_2_open IS NULL OR formatted_hours.day_2_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_2_open AND formatted_day_2_close)
              THEN true
              -- Check if the current day is Wednesday (day 3)
              WHEN EXTRACT(DOW FROM $4::timestamp) = 3
                  AND (formatted_hours.day_3_open IS NULL OR formatted_hours.day_3_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_3_open AND formatted_day_3_close)
              THEN true
              -- Check if the current day is Thursday (day 4)
              WHEN EXTRACT(DOW FROM $4::timestamp) = 4
                  AND (formatted_hours.day_4_open IS NULL OR formatted_hours.day_4_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_4_open AND formatted_day_4_close)
              THEN true
              -- Check if the current day is Friday (day 5)
              WHEN EXTRACT(DOW FROM $4::timestamp) = 5
                  AND (formatted_hours.day_5_open IS NULL OR formatted_hours.day_5_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_5_open AND formatted_day_5_close)
              THEN true
              -- Check if the current day is Saturday (day 6)
              WHEN EXTRACT(DOW FROM $4::timestamp) = 6
                  AND (formatted_hours.day_6_open IS NULL OR formatted_hours.day_6_close IS NULL
                       OR $4::time BETWEEN formatted_hours.formatted_day_6_open AND formatted_day_6_close)
              THEN true
              ELSE false
          END AS is_open
      FROM
          formatted_hours
      WHERE
          ST_DWithin(
              ST_MakePoint($1, $2)::geography,
              ST_MakePoint(formatted_hours.longitude, formatted_hours.latitude)::geography,
              $3
          )
          AND formatted_hours.is_removed = false
      ORDER BY
          distance_in_miles ASC;
        `

    const values = [longitude, latitude, radius, localISOTime];
    const result = await pool.query(query, values);
    res.json(result.rows);
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).json({ error: 'Internal Server error' })
  }
});


router.get('/getAllBathrooms', async (req: Request, res: Response) => {
  const { localISOTime } = req.query;

  console.log('/getAllBathrooms', localISOTime)

  if (!localISOTime) {
    return res.status(400).json({ error: "Missing required query parameters: localISOTime" })
  }

  try {
    const query =
      `--sql
      WITH formatted_hours AS (      
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
          COALESCE("votes_query"."upvotes", 0) AS "upvotes", 
          COALESCE("votes_query"."downvotes", 0) AS "downvotes",
          COALESCE("comments_query"."comments", '[]'::json) AS "comments",
           -- Convert integer hours to text, pad them to 4 digits, and then convert to TIME
        TO_TIMESTAMP(LPAD(opening_hours.day_0_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_0_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_0_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_0_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_1_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_1_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_1_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_1_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_2_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_2_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_2_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_2_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_3_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_3_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_3_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_3_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_4_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_4_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_4_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_4_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_5_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_5_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_5_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_5_close,
        TO_TIMESTAMP(LPAD(opening_hours.day_6_open::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_6_open,
        TO_TIMESTAMP(LPAD(opening_hours.day_6_close::text, 4, '0'), 'HH24MI')::TIME AS formatted_day_6_close
            FROM "restrooms"
      
            LEFT JOIN (
                  SELECT 
                    "restroom_id", 
                    SUM("upvote") AS "upvotes",
                    SUM("downvote") AS "downvotes"
                  FROM "restroom_votes"
                  GROUP BY "restroom_id"
                ) 
                AS "votes_query" ON "restrooms"."id" = "votes_query"."restroom_id"
            
            LEFT JOIN (
                  SELECT 
                    "restroom_id",
                    json_agg(
                      json_build_object(
                        'id', comments.id,
                        'content', comments.content,
                        'user_id', comments.user_id,
                        'inserted_at', comments.inserted_at
                      )
                      order by "inserted_at" DESC
                    ) 
                    AS "comments"
                      FROM "comments"
                      WHERE "comments"."is_removed" = FALSE
                      GROUP BY "comments"."restroom_id"
                      ) 
                      AS "comments_query" ON "restrooms"."id" = "comments_query"."restroom_id"
                      
            LEFT JOIN "opening_hours" ON "restrooms".id="opening_hours".restroom_id)
            
      SELECT
          formatted_hours.*,

          CASE
              -- Check if the current day is Sunday (day 0) based on the user's local time
              WHEN EXTRACT(DOW FROM $1::timestamp) = 0
                  AND (formatted_hours.day_0_open IS NULL OR formatted_hours.day_0_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_0_open AND formatted_day_0_close)
              THEN true
              -- Check if the current day is Monday (day 1)
              WHEN EXTRACT(DOW FROM $1::timestamp) = 1
                  AND (formatted_hours.day_1_open IS NULL OR formatted_hours.day_1_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_1_open AND formatted_day_1_close)
              THEN true
              -- Check if the current day is Tuesday (day 2)
              WHEN EXTRACT(DOW FROM $1::timestamp) = 2
                  AND (formatted_hours.day_2_open IS NULL OR formatted_hours.day_2_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_2_open AND formatted_day_2_close)
              THEN true
              -- Check if the current day is Wednesday (day 3)
              WHEN EXTRACT(DOW FROM $1::timestamp) = 3
                  AND (formatted_hours.day_3_open IS NULL OR formatted_hours.day_3_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_3_open AND formatted_day_3_close)
              THEN true
              -- Check if the current day is Thursday (day 4)
              WHEN EXTRACT(DOW FROM $1::timestamp) = 4
                  AND (formatted_hours.day_4_open IS NULL OR formatted_hours.day_4_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_4_open AND formatted_day_4_close)
              THEN true
              -- Check if the current day is Friday (day 5)
              WHEN EXTRACT(DOW FROM $1::timestamp) = 5
                  AND (formatted_hours.day_5_open IS NULL OR formatted_hours.day_5_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_5_open AND formatted_day_5_close)
              THEN true
              -- Check if the current day is Saturday (day 6)
              WHEN EXTRACT(DOW FROM $1::timestamp) = 6
                  AND (formatted_hours.day_6_open IS NULL OR formatted_hours.day_6_close IS NULL
                       OR $1::time BETWEEN formatted_hours.formatted_day_6_open AND formatted_day_6_close)
              THEN true
              ELSE false
          END AS is_open
      FROM
          formatted_hours
      WHERE formatted_hours.is_removed = false;
        `

    const values = [localISOTime];
    const result = await pool.query(query, values);
    res.json(result.rows);
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).json({ error: 'Internal Server error' })
  }
});

module.exports = router;
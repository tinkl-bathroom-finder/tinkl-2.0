//Types
import { Request, Response } from "express";
import { QueryResult } from 'pg';
import pool from "../pool";
const express = require("express");

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
    const query = /*sql*/
      `
WITH formatted_hours AS (
    SELECT
        restrooms.id AS restroom_id,
        restrooms.longitude,
        restrooms.latitude,
        restrooms.is_removed,
        opening_hours.day_0_open,
        opening_hours.day_0_close,
        opening_hours.day_1_open,
        opening_hours.day_1_close,
        opening_hours.day_2_open,
        opening_hours.day_2_close,
        opening_hours.day_3_open,
        opening_hours.day_3_close,
        opening_hours.day_4_open,
        opening_hours.day_4_close,
        opening_hours.day_5_open,
        opening_hours.day_5_close,
        opening_hours.day_6_open,
        opening_hours.day_6_close,
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
    FROM
        restrooms
    JOIN
        opening_hours
    ON
        restrooms.id = opening_hours.restroom_id
)
SELECT
    formatted_hours.restroom_id,
    formatted_hours.longitude,
    formatted_hours.latitude,
    formatted_hours.is_removed,
    formatted_hours.day_0_open,
    formatted_hours.day_0_close,
    formatted_hours.day_1_open,
    formatted_hours.day_1_close,
    formatted_hours.day_2_open,
    formatted_hours.day_2_close,
    formatted_hours.day_3_open,
    formatted_hours.day_3_close,
    formatted_hours.day_4_open,
    formatted_hours.day_4_close,
    formatted_hours.day_5_open,
    formatted_hours.day_5_close,
    formatted_hours.day_6_open,
    formatted_hours.day_6_close,
    ST_Distance(
        ST_MakePoint($1, $2)::geography,
        ST_MakePoint(formatted_hours.longitude, formatted_hours.latitude)::geography
    ) AS distance,
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
    distance ASC;
        `

    const values = [longitude, latitude, radius, localISOTime];
    const result = await pool.query(query, values);
    res.json(result.rows);
  } catch (error) {
    console.error('Error executing query', error);
    res.status(500).json({ error: 'Internal Server error' })
  }
});


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
      res.send(response.rows);
    })
    .catch((error: Error) => {
      console.log("fail:", error);
      res.sendStatus(500);
    });
});

module.exports = router;
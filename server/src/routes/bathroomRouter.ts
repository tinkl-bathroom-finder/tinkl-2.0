//Types
import { Request, Response } from "express";
import { QueryResult } from 'pg';
import pool from "../pool";
const express = require("express");

const router = express.Router();


//Using this route requires installation of postgis
//on a mac: brew install postgis
router.get('/getBathroomsByRadius', async (req: Request, res: Response) => {
    const { latitude, longitude, radius} = req.query;

    console.log('/getBathroomsByRadius', latitude, longitude, radius)

    if (!latitude || !longitude || !radius) {
        return res.status(400).json({ error: "Missing required query parameters: latitude, longitude and radius"})
    }

    try {
        const query = /*sql*/
        `
        SELECT 
        id, 
        api_id, 
        name, 
        street, 
        city, 
        state, 
        accessible, 
        unisex, 
        directions, 
        latitude, 
        longitude, 
        created_at, 
        updated_at, 
        country, 
        changing_table, 
        is_removed, 
        is_single_stall, 
        is_multi_stall, 
        is_flagged, 
        place_id,
        ST_Distance(
          ST_MakePoint($1, $2)::geography, 
          ST_MakePoint(longitude, latitude)::geography
        ) AS distance
      FROM 
        restrooms
      WHERE 
        ST_DWithin(
          ST_MakePoint($1, $2)::geography, 
          ST_MakePoint(longitude, latitude)::geography, 
          $3
        )
        AND is_removed = false
      ORDER BY 
        distance ASC;
        `
        
        const values = [longitude, latitude, radius];
        const result = await pool.query(query, values);
        res.json(result.rows);
    } catch (error) {
        console.error('Error executing query', error);
        res.status(500).json({error: 'Internal Server error'})
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
//Types
import { Request, Response } from "express";
import { QueryResult } from 'pg';
import pool from "../pool";
const express = require("express");
const axios = require('axios');
const router = express.Router();

router.get('/', async (req: Request, res: Response) => {
    const apiKey = process.env.GEOCODING_API_KEY
    const { convertedAddress } = req.query;

    console.log('req.query which should be an object with convertedAddress:', req.query)

    axios({
        method: "GET",
        url: `https://maps.googleapis.com/maps/api/geocode/json?key=${apiKey}&address=${req.query.convertedAddress}`
      })
    
        .then((response: { data: any; }) => {
          console.log('Geocode API Response', response.data);
          res.send(response.data);
        })
        .catch((error: any) => {
          console.log("Error in Geocode get request", error);
        })

})

module.exports = router;
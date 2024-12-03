//Types
import { Request, Response } from "express";
import { rejectUnauthenticated } from '../strategies/authenticationPassport';
import pool from "../pool";
const express = require("express");

const router = express.Router();

router.post('/', async (req: Request, res: Response) => {
    console.log('Contact route called.')
    const query = `
    INSERT INTO "contact" (user_id, details)
    VALUES ($1, $2);
    `
  const values = [req.body.userId, req.body.feedback]
  pool.query(query, values)
    .then((dbRes) => {
      res.sendStatus(201)
    })
    .catch((dbErr) => {
      console.error('Contact post route failed:', dbErr)
      res.sendStatus(500)
    })
})

module.exports = router;
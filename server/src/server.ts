import express from 'express';
import { Router } from "express";
const bodyParser = require('body-parser');

//Types
import { Express } from 'express';
import { Request, Response } from 'express';

//Routes
const bathroomRequest = require('./Routes/bathroomRequest');

const app: Express = express();
const port: number = 5001;

app.get('/', (req: Request, res: Response) => {
    res.send('This thing is working get route /');
    console.log('Route called')
});

app.use('/api', bathroomRequest);

app.listen(port, '0.0.0.0', () => {
    console.log(`Server Running at http://0.0.0.0:${port}`);
})

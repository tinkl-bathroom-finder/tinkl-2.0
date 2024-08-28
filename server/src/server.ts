const cors = require('cors');
import express from 'express';
import session from 'express-session';
import passport from 'passport';
import dotenv from 'dotenv';

import './strategies/passportConfig';

//Types
import { Express } from 'express';
import { Request, Response } from 'express';
import { rejectUnauthenticated } from './strategies/authenticationPassport';

//Routes
const bathroomRequest = require('./Routes/bathroomRequest');
const userRouter = require('./routes/userRouter');

const app: Express = express();
const port: number = 5001;

dotenv.config();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(session({
    secret: process.env.SERVER_SECRET as string,
    resave: false,
    saveUninitialized: false
}));

app.use(passport.initialize());
app.use(passport.session());

//Test route no auth
app.get('/', (req: Request, res: Response) => {
    res.send('This thing is working get route /');
    console.log('Route called')
});

//Test route with auth
app.get('/auth', rejectUnauthenticated, (req: Request, res: Response) => {
    console.log('auth route called');
    res.send('Authorization granted');
})

app.use('/api', bathroomRequest);
app.use('/api', userRouter);

app.listen(port, '0.0.0.0', () => {
    console.log(`Server Running at http://0.0.0.0:${port}`);
})

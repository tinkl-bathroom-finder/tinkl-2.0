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
const bathroomRouter = require('./Routes/bathroomRouter');
const userRouter = require('./routes/userRouter');

const app: Express = express();
const port: number = 5001;

dotenv.config();

const corsOptions = {
    origin: process.env.FRONTEND_URL, // Replace with your frontend origin
    credentials: true, // This allows cookies to be sent across origins
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

app.use(session({
    secret: process.env.SERVER_SECRET as string,
    resave: false,
    saveUninitialized: false,
    cookie: { secure: process.env.NODE_ENV === 'production' ? true : false }
}));

app.use(passport.initialize());
app.use(passport.session());

//Test route no auth
app.get('/', (req: Request, res: Response) => {
    res.send('This thing is working get route /');
});

//Test route with auth
app.get('/auth', rejectUnauthenticated, (req: Request, res: Response) => {
    res.send('Authorization granted');
})

app.use('/api', bathroomRouter);
app.use('/user', userRouter);

app.listen(port, '0.0.0.0', () => {
    console.log(`Server Running at http://0.0.0.0:${port}`);
})

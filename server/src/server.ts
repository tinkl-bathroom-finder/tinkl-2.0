const cors = require('cors');
import express, { NextFunction } from 'express';
import session from 'express-session';
// import passport from 'passport';
import dotenv from 'dotenv';
// import https from 'https';
import http from 'http';
// import fs from 'fs';
import path from 'path';

const passport = require('./strategies/passportConfig');

//Types
import { Express } from 'express';
import { Request, Response } from 'express';
import { rejectUnauthenticated } from './strategies/authenticationPassport';

//Routes
const bathroomRouter = require('./routes/bathroomRouter');
const userRouter = require('./routes/userRouter');
const geocodeRouter = require('./routes/geocodeRouter');
const contactRouter = require('./routes/contactRouter');
const feedbackRouter = require('./routes/feedbackRouter');

const app: Express = express();
const port: number = 5001;

dotenv.config();

// const sslOptions = {
//     key: fs.readFileSync(path.join('/etc/letsencrypt/live/transphasic.asuscomm.com/privkey.pem')),
//     cert: fs.readFileSync(path.join('/etc/letsencrypt/live/transphasic.asuscomm.com/fullchain.pem'))
// };

const corsOptions = {
    origin: function (origin: any, callback: any) {
        const allowedOrigins = [
            'http://localhost:5173',
            'https://localhost:5173',
            'http://transphasic.asuscomm.com',
            'https://transphasic.asuscomm.com',
        ];

        if (allowedOrigins.includes(origin) || !origin) {
            callback(null, true);  // Allow if origin matches or if no origin
        } else {
            callback(new Error('Not allowed by CORS'));  // Reject otherwise
        }
    },
    credentials: true,  // Allow cookies to be sent across origins
    // methods: ['GET', 'POST', 'PUT', 'DELETE'],
    // allowedHeaders: ['Content-Type', 'Authorization'],
    // exposedHeaders: ['Content-Length', 'X-Kuma-Revision'],
};

console.log('*************', process.env.FRONTEND_URL, '************************')
console.log('Node ENV', process.env.NODE_ENV);

app.use(cors(corsOptions));
app.use(express.json());
// app.use(express.urlencoded({ extended: false }));

app.use(session({
    secret: process.env.SERVER_SECRET as string,
    resave: false,
    saveUninitialized: false,
    proxy: process.env.NODE_ENV === 'production',
    cookie: {

        secure: process.env.NODE_ENV === 'production',
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000,
        sameSite: process.env.NODE_ENV === 'production' ? 'lax' : 'strict'
    }
}));

app.use(passport.initialize());
app.use(passport.session());

// Serve static files from the Vite build directory (dist)
app.use(express.static(path.join(__dirname, '../client/dist')));

//Test route no auth
app.get('/testRoute', (req: Request, res: Response, next: NextFunction) => {
    console.log('testRoute called', req.isAuthenticated);
    res.send(req.isAuthenticated() ? 'Authenticated' : 'Not Authenticated');
});

declare module 'express-session' {
    interface SessionData {
        views: number;
    }
}

//This is another testing route
app.get('/viewCount', (req, res) => {
    if (!req.session.views) {
        req.session.views = 1;
    } else {
        req.session.views++;
    }
    res.send(`Number of views: ${req.session.views}`);
});

//Test route with auth
app.get('/auth', rejectUnauthenticated, (req: Request, res: Response) => {
    res.send('Authorization granted');
});


app.use('/api/bathrooms', bathroomRouter);
app.use('/api/feedback', feedbackRouter)
app.use('/api/user', userRouter);
app.use('/api/getPlaceID', geocodeRouter);
app.use('/api/contact', contactRouter);

const PORT = parseInt(process.env.PORT || '5001', 10);
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
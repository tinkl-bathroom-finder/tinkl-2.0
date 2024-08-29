# To run this app

git clone
cd tinkl-2.0
npm install

cd server
npm install

cd ../client
npm install

## Structure
The front and backend are separate applications with their own separate dependencies and node_modules folder. 
The first npm install done in the main folder installs only "concurrently" - this allows one script to start 
both the backend server and the development server from the main folder : "npm run dev"

.env files are separate for the front and backend. The back end .env requires:

SERVER_URL="http://localhost:5001"
FRONTEND_URL="http://localhost:5173"
SERVER_SECRET=xxxxxxxxxx
MAILTRAP_HOST=sandbox.smtp.mailtrap.io
MAILTRAP_PORT=xxx
MAILTRAP_USERNAME=xxxx
MAILTRAP_PASSWORD=xxxx

The front end .env file requires:
VITE_API_BASE_URL="http://localhost:5001"

## Server
The server is pretty basic right now. It connects to the database, uses local auth, allows password resets and registers new users. 

### There are two routes:
1 - bathroomRouter - one route that pulls all the bathroom data from the database
2 - userRouter - handles login, logout, password reset and registration

### Strategies
This covers passport configuration, password hashing and user auth

### types
Contains only one type at the moment for the user and is probably unncessary

## Front End
Basic infrastructure is in place. Redux is set up and operational with three reducers: 
1 - bathroomReducer - contains all the bathroom data pulled from the database
2 - userReducer - contains all user info plus location data
3 - tinklOptionsReducer - contains all the toggles, switches and things that make the app work

### Types
Custom types for the redux reducers and the rootState. This gives developers instant access to the object structure of all the reducers

## Components

### LoginScreen - covers all the login things
### ResetPassword - only accessible via a reset link sent out by the server
### tinklLogo - SVG of the logo(no background) that accepts height and width props
### UserMenu - the little menu with a little avatar thingy
### LeafletMap - copied wholesale over - doesn't work 
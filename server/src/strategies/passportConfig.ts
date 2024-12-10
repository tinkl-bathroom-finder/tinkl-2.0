import passport from "passport";
import { Strategy as LocalStrategy } from "passport-local";
import bcrypt from 'bcryptjs';
import pool from '../pool';

//Types
import { UserType } from "../types/UserType";

passport.use(
    new LocalStrategy(async (username, password, done) => {
        try {
            const queryString = `
                SELECT * FROM "user"
                WHERE username = $1
            `;
            const res = await pool.query(queryString, [username]);
            const user: UserType | undefined = res.rows[0];

            if (!user) {
                console.log('Incorrect username or password');
                return done(null, false, { message: 'Incorrect username or password' });
            }
            const isMatch = await bcrypt.compare(password, user.password);

            if (!isMatch) {
                console.log('Incorrect username or password');
                return done(null, false, { message: 'Incorrect username or password' });
            }

            if (user.is_removed) {
                console.log('user removed');
                return done(null, false, { message: 'User has been removed' });
            }

            return done(null, user);
        } catch (error) {
            return done(error);
        }
    })
);

passport.serializeUser((user: any, done) => {
    done(null, user.id);
});

passport.deserializeUser(async (id: number, done) => {
    try {
        const res = await pool.query('SELECT * FROM "user" WHERE id = $1', [id]);
        const user: UserType | undefined = res.rows[0];
        done(null, user);
    } catch (err) {
        done(err);
    }
});

module.exports = passport;
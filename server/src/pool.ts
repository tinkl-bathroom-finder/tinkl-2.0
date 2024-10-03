
import { Pool } from 'pg';
let pool: Pool;

console.log('************** DATABASE_URL', process.env.DATABASE_URL, '***************')
if (process.env.DATABASE_URL) {
    pool = new Pool({
        connectionString: process.env.DATABASE_URL,
    });
}

else {
    pool = new Pool({
        // user: 'postgres',
        // password: 'postgres',
        host: 'localhost',
        port: 5432,
        database: 'bathrooms',
    });
}
export default pool;

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
        user: process.env.PGUSER,
        password: process.env.PG_PASSWORD,
        host: 'localhost',
        port: 5432,
        database: 'bathrooms',
    });
}
export default pool;
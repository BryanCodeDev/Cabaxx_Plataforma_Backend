const mysql = require('mysql2/promise');
const fs = require('fs');
const path = require('path');

async function runSeeds() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    multipleStatements: true,
  });

  try {
    const seedFiles = ['seed_data.sql', 'seed-demo.sql'];
    
    for (const seedFile of seedFiles) {
      const seedPath = path.join(__dirname, seedFile);
      if (fs.existsSync(seedPath)) {
        console.log(`Running seed: ${seedFile}...`);
        const sql = fs.readFileSync(seedPath, 'utf8');
        await connection.query(sql);
        console.log(`Seed ${seedFile} completed`);
      }
    }
    
    console.log('All seeds completed successfully');
  } catch (error) {
    console.error('Seeding failed:', error);
    process.exit(1);
  } finally {
    await connection.end();
  }
}

runSeeds();

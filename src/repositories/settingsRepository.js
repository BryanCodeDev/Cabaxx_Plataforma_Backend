const db = require('../config/database');
const SettingModel = require('../models/Setting.model');

async function getByArtist(artistId) {
  const rows = await db.query(`SELECT setting_key, setting_value FROM ${SettingModel.tableName} WHERE artist_id = ?`, [artistId]);
  return rows.reduce((acc, r) => { acc[r.setting_key] = r.setting_value; return acc; }, {});
}

async function setMany(artistId, settings) {
  for (const [key, value] of Object.entries(settings)) {
    await db.query(
      `INSERT INTO ${SettingModel.tableName} (artist_id, setting_key, setting_value) VALUES (?, ?, ?)
       ON DUPLICATE KEY UPDATE setting_value = ?`,
      [artistId, key, value, value],
    );
  }
  return getByArtist(artistId);
}

module.exports = { getByArtist, setMany };

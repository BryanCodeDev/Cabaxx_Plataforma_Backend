const db = require('../config/database');
const SettingModel = require('../models/Setting.model');

async function getByArtist(artistId) {
  const rows = await db.query(
    `SELECT \`key\`, value, type FROM ${SettingModel.tableName} WHERE artist_id = ?`,
    [artistId],
  );
  return rows.reduce((acc, r) => {
    let v = r.value;
    if (r.type === 'boolean') {
      v = v === 'true' || v === '1' || v === true;
    } else if (r.type === 'number') {
      v = Number(v);
    } else if (r.type === 'json') {
      try { v = JSON.parse(v); } catch (e) { v = null; }
    }
    acc[r.key] = v;
    return acc;
  }, {});
}

async function setMany(artistId, settings) {
  for (const [key, value] of Object.entries(settings)) {
    const type =
      typeof value === 'boolean' ? 'boolean'
      : typeof value === 'number' ? 'number'
      : typeof value === 'object' ? 'json'
      : 'string';
    const stored = type === 'object' ? JSON.stringify(value) : String(value);

    await db.query(
      `INSERT INTO ${SettingModel.tableName} (artist_id, \`key\`, value, type)
       VALUES (?, ?, ?, ?)
       ON DUPLICATE KEY UPDATE value = VALUES(value), type = VALUES(type)`,
      [artistId, key, stored, type],
    );
  }
  return getByArtist(artistId);
}

module.exports = { getByArtist, setMany };

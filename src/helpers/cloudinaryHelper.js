const cloudinary = require('../config/cloudinary');
const { buildPublicId } = require('./fileHelper');

async function uploadBuffer(buffer, { folder = 'map', resourceType = 'auto', publicName = 'file' } = {}) {
  if (!cloudinary.config().cloud_name) {
    // Cloudinary no configurado: devolver marcador local para no romper flujo en dev
    return `local://${folder}/${publicName}-${Date.now()}`;
  }
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      { resource_type: resourceType, folder, public_id: buildPublicId(folder, publicName) },
      (error, result) => (error ? reject(error) : resolve(result.secure_url)),
    );
    stream.end(buffer);
  });
}

async function destroy(url, resourceType = 'image') {
  if (!url || !url.includes('res.cloudinary.com')) return;
  const matches = url.match(/map\/(.+)\./);
  if (matches) {
    await cloudinary.uploader.destroy(`map/${matches[1]}`, { resource_type: resourceType });
  }
}

module.exports = { uploadBuffer, destroy };

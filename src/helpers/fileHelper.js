const ALLOWED_IMAGE = ['.jpg', '.jpeg', '.png', '.webp', '.gif'];

function isImage(filename = '') {
  return ALLOWED_IMAGE.includes(filename.slice(filename.lastIndexOf('.')).toLowerCase());
}

function buildPublicId(folder, name) {
  return `${folder}/${Date.now()}-${name}`;
}

module.exports = { isImage, buildPublicId };

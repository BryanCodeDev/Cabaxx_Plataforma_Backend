const galleryRepository = require('../repositories/gallery.repository');
const cloudinaryHelper = require('../helpers/cloudinaryHelper');
const { NotFoundError } = require('../exceptions');

async function getGallery(artistId, filters = {}) {
  return galleryRepository.findAll(artistId, filters);
}

async function uploadItem(artistId, data, file) {
  if (!file) throw new ValidationErrorRequired();
  const isVideo = (file.mimetype || '').startsWith('video/');
  const fileUrl = await cloudinaryHelper.uploadBuffer(file.buffer, {
    folder: 'map/gallery',
    resourceType: isVideo ? 'video' : 'image',
    publicName: `item-${Date.now()}`,
  });
  return galleryRepository.create({
    artist_id: artistId,
    title: data.title || file.originalname,
    description: data.description || null,
    file_url: fileUrl,
    file_type: isVideo ? 'video' : 'image',
    category: data.category || 'general',
    sort_order: data.sort_order ? Number(data.sort_order) : 0,
    status: 'active',
  });
}

async function reorderItems(artistId, items) {
  // Validar que los items pertenezcan al artista antes de reordenar
  for (const it of items) {
    const found = await galleryRepository.findById(it.id, artistId);
    if (!found) throw new NotFoundError(`Gallery item ${it.id} not found`);
  }
  await galleryRepository.updateSortOrder(items);
  return true;
}

async function deleteItem(id, artistId) {
  const item = await galleryRepository.findById(id, artistId);
  if (!item) throw new NotFoundError('Gallery item not found');
  const ok = await galleryRepository.deleteById(id, artistId);
  if (ok) {
    await cloudinaryHelper.destroy(item.file_url, item.file_type === 'video' ? 'video' : 'image');
  }
  return ok;
}

// Error auxiliar para archivo faltante
function ValidationErrorRequired() {
  const err = new Error('File required');
  err.statusCode = 422;
  err.code = 'VALIDATION_ERROR';
  return err;
}

module.exports = { getGallery, uploadItem, reorderItems, deleteItem };

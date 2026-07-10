const commentRepository = require('../repositories/commentRepository');
const { NotFoundError, ValidationError } = require('../exceptions');

async function getComments(artistId, filters = {}) {
  return commentRepository.findAll(artistId, filters);
}

async function getComment(id, artistId) {
  const comment = await commentRepository.findById(id, artistId);
  if (!comment) throw new NotFoundError('Comment not found');
  return comment;
}

async function createComment(artistId, userId, data) {
  if (!data.content || !String(data.content).trim()) {
    throw new ValidationError('El comentario no puede estar vacío');
  }
  return commentRepository.create({
    artist_id: artistId,
    user_id: userId,
    reference_id: data.reference_id,
    reference_type: data.reference_type,
    content: String(data.content).trim(),
    parent_id: data.parent_id || null,
    status: 'approved',
  });
}

async function updateComment(id, artistId, data) {
  if (!data.content || !String(data.content).trim()) {
    throw new ValidationError('El comentario no puede estar vacío');
  }
  return commentRepository.update(id, { content: String(data.content).trim() }, artistId);
}

async function deleteComment(id, artistId) {
  const ok = await commentRepository.remove(id, artistId);
  if (!ok) throw new NotFoundError('Comment not found');
  return true;
}

async function countComments(artistId, referenceType, referenceId) {
  return commentRepository.countByReference(artistId, referenceType, referenceId);
}

module.exports = { getComments, getComment, createComment, updateComment, deleteComment, countComments };

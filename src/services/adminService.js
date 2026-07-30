const adminRepository = require('../repositories/adminRepository');

async function listArtists({ page, limit, isActive } = {}) {
  return adminRepository.listArtists({ page, limit, isActive });
}

async function listUsers({ page, limit } = {}) {
  return adminRepository.listUsers({ page, limit });
}

module.exports = { listArtists, listUsers };

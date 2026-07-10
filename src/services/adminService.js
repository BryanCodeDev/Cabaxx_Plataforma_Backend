const adminRepository = require('../repositories/adminRepository');

async function listArtists({ page, limit, isActive } = {}) {
  return adminRepository.listArtists({ page, limit, isActive });
}

async function listUsers({ page, limit } = {}) {
  return adminRepository.listUsers({ page, limit });
}

async function listSubscriptions({ page, limit } = {}) {
  return adminRepository.listSubscriptions({ page, limit });
}

module.exports = { listArtists, listUsers, listSubscriptions };

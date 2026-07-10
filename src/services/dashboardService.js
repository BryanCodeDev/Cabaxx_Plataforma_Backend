const dashboardRepository = require('../repositories/dashboardRepository');

async function summary(artistId) {
  return dashboardRepository.summary(artistId);
}

module.exports = { summary };

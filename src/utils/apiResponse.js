const httpStatus = require('./httpStatus');

function buildSuccess({ data = null, message = 'OK', pagination = null, meta = null } = {}) {
  const response = { success: true, message, data };
  if (pagination) response.pagination = pagination;
  if (meta) response.meta = meta;
  return response;
}

function buildError({ message = 'Error', code = 'INTERNAL_ERROR', details = null, statusCode = httpStatus.INTERNAL_SERVER_ERROR } = {}) {
  return { success: false, message, error: { code, details }, statusCode };
}

function paginate(page = 1, limit = 20, total = 0) {
  const currentPage = Math.max(1, Number(page) || 1);
  const perPage = Math.min(100, Math.max(1, Number(limit) || 20));
  const totalPages = Math.ceil(total / perPage) || 0;
  return {
    page: currentPage,
    limit: perPage,
    total,
    totalPages,
  };
}

module.exports = { buildSuccess, buildError, paginate };

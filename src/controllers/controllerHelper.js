const apiResponse = require('../utils/apiResponse');

function ok(res, data, message = 'OK', status = 200) {
  return res.status(status).json(apiResponse.buildSuccess({ data, message }));
}

function paginated(res, rows, total, page, limit, message = 'OK') {
  return res
    .status(200)
    .json(apiResponse.buildSuccess({ data: rows, message, pagination: apiResponse.paginate(page, limit, total) }));
}

function created(res, data, message = 'Created') {
  return ok(res, data, message, 201);
}

function noContent(res) {
  return res.status(204).end();
}

module.exports = { ok, paginated, created, noContent };

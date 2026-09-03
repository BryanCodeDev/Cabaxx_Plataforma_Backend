const apiResponse = require('../utils/apiResponse');

function ok(res, data, message = 'OK', status = 200) {
  return res.status(status).json(apiResponse.buildSuccess({ data, message }));
}

function paginated(res, rows, total, page, limit, message = 'OK') {
  return res
    .status(200)
    .json(apiResponse.buildSuccess({ data: rows, message, pagination: apiResponse.paginate(page, limit, total) }));
}

// Variante con envoltura tipada: `{ data: { <resource>: { rows, total } }, pagination }`.
// Mantiene compatibilidad con el frontend existente que lee
// `res.data.<resource>.rows` en lugar de un array directo.
function paginatedAs(res, resource, rows, total, page, limit, message = 'OK') {
  return res.status(200).json(
    apiResponse.buildSuccess({
      data: { [resource]: { rows, total } },
      message,
      pagination: apiResponse.paginate(page, limit, total),
    }),
  );
}

function created(res, data, message = 'Created') {
  return ok(res, data, message, 201);
}

function noContent(res) {
  return res.status(204).end();
}

function badRequest(res, message = 'Bad request', details = null) {
  return res.status(422).json(apiResponse.buildError({ message, code: 'VALIDATION_ERROR', details }));
}

module.exports = { ok, paginated, paginatedAs, created, noContent, badRequest };

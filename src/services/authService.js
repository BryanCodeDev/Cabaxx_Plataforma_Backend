const crypto = require('crypto');
const { hashPassword, comparePassword } = require('../utils/password');
const { issueTokens, verifyRefreshToken } = require('../utils/jwt');
const authRepository = require('../repositories/authRepository');
const tokenService = require('./tokenService');
const emailService = require('./emailService');
const { NotFoundError, ConflictError, UnauthorizedError } = require('../exceptions');
const { resetPasswordTemplate } = require('../helpers/emailTemplates');
const env = require('../config/env');

async function register({ email, password, firstName, lastName, role = 'user', artistId = null }) {
  const existing = await authRepository.findByEmail(email);
  if (existing) throw new ConflictError('Email already registered');
  const passwordHash = await hashPassword(password);
  const user = await authRepository.create({ email, passwordHash, role, artistId, firstName, lastName });
  return sanitize(user);
}

async function login({ email, password }) {
  const user = await authRepository.findByEmail(email);
  if (!user || user.status !== 'active') throw new UnauthorizedError('Invalid credentials');
  const ok = await comparePassword(password, user.password_hash);
  if (!ok) throw new UnauthorizedError('Invalid credentials');
  const roles = await authRepository.findRolesByUserId(user.id);
  const { role, artistId } = resolvePrimaryRole(roles);
  const tokens = issueTokens({ ...user, role, artistId });
  const expiresAt = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000);
  await tokenService.storeRefreshToken(user.id, crypto.createHash('sha256').update(tokens.refreshToken).digest('hex'), expiresAt);
  return { ...tokens, user: { ...sanitize(user), roles } };
}

async function refresh(refreshToken) {
  const payload = verifyRefreshToken(refreshToken);
  const hash = crypto.createHash('sha256').update(refreshToken).digest('hex');
  const stored = await tokenService.findRefreshToken(hash);
  if (!stored) throw new UnauthorizedError('Refresh token revoked');
  const user = await authRepository.findById(payload.id);
  if (!user) throw new UnauthorizedError('User not found');
  const roles = await authRepository.findRolesByUserId(user.id);
  const { role, artistId } = resolvePrimaryRole(roles);
  const tokens = issueTokens({ ...user, role, artistId });
  return { ...tokens, user: { ...sanitize(user), roles } };
}

async function me(userId) {
  const user = await authRepository.findById(userId);
  if (!user) throw new NotFoundError('User not found');
  const roles = await authRepository.findRolesByUserId(user.id);
  return { ...sanitize(user), roles };
}

async function logout(refreshToken) {
  if (refreshToken) {
    const hash = crypto.createHash('sha256').update(refreshToken).digest('hex');
    await tokenService.revokeRefreshToken(hash);
  }
}

async function logoutAll(userId) {
  await tokenService.revokeAllForUser(userId);
}

async function forgotPassword(email) {
  const user = await authRepository.findByEmail(email);
  if (!user) throw new NotFoundError('Email not registered');
  const link = `${env.clientUrl}/reset-password?token=${crypto.randomBytes(20).toString('hex')}`;
  await emailService.send({ to: email, subject: 'Restablecer contraseña', html: resetPasswordTemplate(user.first_name, link) });
}

async function resetPassword(token, password) {
  return { reset: true };
}

function sanitize(user) {
  const { password_hash, ...rest } = user;
  return rest;
}

// Determina el rol principal para el JWT y el scope de admin.
// Prioridad: superadmin (global) > artist_admin (con artistId) > user.
function resolvePrimaryRole(roles) {
  const has = (slug) => roles.some((r) => r.role === slug);
  if (has('superadmin')) return { role: 'superadmin', artistId: null };
  const admin = roles.find((r) => r.role === 'artist_admin');
  if (admin) return { role: 'artist_admin', artistId: admin.artistId };
  return { role: 'user', artistId: null };
}

module.exports = { register, login, refresh, me, logout, logoutAll, forgotPassword, resetPassword, sanitize };

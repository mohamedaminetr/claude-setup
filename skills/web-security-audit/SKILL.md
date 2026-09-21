---
name: web-security-audit
description: "Audit or build authentication, sessions and authorization for any website or API, using the user's Web Security Guide (passwords, cookies, refresh rotation, CSRF, roles and ownership, 2FA, passkeys, social login, email tokens, network hardening). Use when a project has login, sessions, roles, user data or an API, before it goes live, when starting one, or when the user types /web-security-audit."
---

# /web-security-audit

Source: the user's "Web Security Guide" (reference project: RentCar, Node/Express/MongoDB + Angular). Go through the checklist below against THIS codebase. For each item: found where it applies (or confirm it does not, e.g. a site with no login), fix it in code, and finish with a table: **item · found · changed · I still need to do**. Keep fixes minimal. Items that don't apply to a project without accounts (sessions, 2FA, passkeys, social login, roles) are marked "n/a, no accounts" and skipped, but say so.

Two rules: (1) never invent crypto, use standard libraries (bcrypt/argon2/scrypt, jsonwebtoken, @simplewebauthn/server, otplib). (2) If the project should not own all this, use a managed provider (Auth0, Clerk, Supabase Auth, Firebase Auth) and do only items 5, 6, 7 and 11 yourself.

## Priority checklist (do in this order)
1. **HTTPS everywhere** (plus HSTS). Nothing else matters without it.
2. **Hash passwords** with bcrypt (cost 10), argon2 or scrypt. Never MD5 or plain SHA. Password length 8 to 72 (bcrypt ignores bytes past 72).
3. **Session tokens in `httpOnly; Secure; SameSite=Lax` cookies**, never `localStorage`.
4. **Short-lived access token (about 15 min) plus a revocable refresh token** stored hashed on the server.
5. **Validate input on the server, always.** Allow-lists of writable fields (never take `role` from the request body: mass assignment). Force identifiers and credentials to plain strings (blocks NoSQL injection like `{"email": {"$ne": null}}`); use parameterised queries or an ORM in SQL.
6. **Ownership check on every endpoint that takes an ID** (IDOR/BOLA is the number one API bug). A role check says "owners can edit vehicles", not whose. List endpoints filter by `owner = req.user.id`.
7. **Deny by default:** a global auth guard with a short public-path list, so a forgotten route is still protected.
8. **CSRF protection whenever cookies are used:** custom header (e.g. `X-Requested-With`) on POST/PUT/DELETE plus SameSite=Lax; the CORS allow-list refuses cross-site custom headers.
9. **Rate limits** on login, signup, reset and email sending (per IP; `skipSuccessfulRequests: true` so real users are not locked out).
10. **Generic error messages** for auth failures ("Invalid email or password"). Never reveal whether an email exists.
11. **Security headers** (helmet in Express, or the framework's equivalent) and a **CORS allow-list** with `credentials: true`.
12. **Keep secrets out of git** (`.env` ignored). Refuse to boot with a missing or weak secret (JWT secret at least 32 chars; generate with `node -e "console.log(require('crypto').randomBytes(48).toString('base64url'))"`).
13. **2FA or passkeys** for sensitive accounts (admins first).
14. **Log and test:** keep a security test file that tries the attacks.

## Details to apply

**Login.** Compare against a `DUMMY_HASH` when the user does not exist, so "unknown email" and "wrong password" take the same time (no timing attack). One generic 401 message. Register always sets `role: "client"`.

**Sessions.** Two cookies: `access` = signed JWT (id, role, session id), 15 min, path `/`, nothing stored server-side; `refresh` = random 32-byte secret, 7 days (hard cap 30), path `/auth` only, server stores only its SHA-256 hash in a `sessions` collection (TTL index deletes expired ones). Pin the JWT algorithm (`algorithms: ["HS256"]`) to block `alg: none`. Every request checks the session still exists (this is what makes logout instant and enables "sign out everywhere"). Sign-out must delete the server-side session, not just clear the cookie.

**Refresh with rotation and theft detection.** Valid secret: issue a new one, keep the old hash as `prevHash`, set both cookies. Secret equals `prevHash`: if rotated under 10 seconds ago it is two tabs racing (only issue a new access token); otherwise the old token was copied, so delete ALL the user's sessions. Anything else: delete the session, 401. Rotate with compare-and-swap (`findOneAndUpdate` keyed on the current `tokenHash`) and compare secrets with `crypto.timingSafeEqual`.

**Frontend.** `withCredentials: true` plus the CSRF header on every request; on a 401 call `/auth/refresh` once and replay the request. Do not retry-refresh on the auth endpoints themselves.

**Roles.** 401 = not logged in, 403 = logged in but not allowed.

**TOTP 2FA.** `beginSetup` shows a QR but enables nothing; `enable` requires a valid code first (proves the app has the secret). Return 8 one-time recovery codes, store only their hashes, remove with `$pull`. Encrypt the TOTP secret at rest with AES-256-GCM (random 12-byte IV), mark those fields `select: false`. Reject replays by storing `lastStep`. Password correct plus 2FA on: issue NO session, return a 5-minute signed challenge (`purpose: "2fa"`) with at most 5 attempts.

**Passkeys (WebAuthn).** Use `@simplewebauthn/server`. Random single-use challenge kept 5 minutes and deleted the moment it is looked up; `expectedOrigin` and `expectedRPID` must match the real site; track the counter; adding a passkey must be finished by the same logged-in user.

**Social login.** Verify the ID token signature and check the audience (`aud` equals your client id). Account-squatting defence: before handing over an account whose email was never verified, wipe its password, passkeys and 2FA, mark verified, revoke all sessions.

**Email verification and password reset tokens.** 256-bit random token, only its hash stored, 1 hour for reset and 24 hours for verification, issuing a new one deletes the old (`deleteMany`), consume with atomic `findOneAndDelete` (two clicks cannot both work), scoped by type (a verify token cannot reset a password).

**Network.** helmet; CORS allow-list; rate limits (20 failed auth per 15 min per IP, 10 emails per hour); body limits (100 KB JSON, larger only on the upload route); per-user limits on costly actions; authenticate sockets with the same JWT.

## Known weaknesses to flag in every audit
- Rate limits, 2FA counters and passkey challenges kept in server memory only work with one instance: move them to Redis (or the host's firewall) before scaling.
- No per-account lockout: limits are per IP, so a botnet can keep guessing one account. Add per-account throttling.
- No breached-password check (for example Have I Been Pwned).
- Rotate any secret that was ever shared or committed.

## Output
A short "Found / Changed / You still need to" block per area, then the summary table. Report honestly what does not apply.

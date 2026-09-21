---
name: money-leak-audit
description: "Audit a project for the five ways a vibe-coded app loses money with zero users (hosting bill with no ceiling, accessibility, database Row Level Security, SMS/email consent, uncapped compute), fix what code can fix, and hand back what only the owner can do in a dashboard. Run before any project goes live, when starting a new project, or when the user types /money-leak-audit."
---

# /money-leak-audit

Audit the current codebase for the five items below, in order. For each one: find where it applies in THIS codebase (or confirm it does not), fix it directly in code, and at the end give a summary table: **item · what you found · what you changed · what I still need to do myself**. Do not skip an item because it "probably doesn't apply": check, then say so.

Keep it minimal (the user asked for minimal): the smallest fix that closes the hole, no new services or dependencies unless nothing simpler works, short Found / Changed / You-still-need-to blocks. This is a code fix, not legal advice; spend caps and consent copy are the owner's.

## 1. Hosting: a bill with no ceiling
Find how the site is deployed (netlify.toml, vercel.json, firebase.json, Dockerfile, fly.toml, render.yaml, GitHub Actions). Then:
- (a) Add rate limiting to every public endpoint and to the site itself where the host supports it (edge functions, middleware, Cloudflare rules): per-IP limits with a sane burst.
- (b) Put every large static asset (video, images over 200 KB, downloads) behind a CDN with caching headers, or move it to object storage, so one page view is not one origin hit.
- (c) Add a hard spend cap or bandwidth alert wherever config allows it; tell the owner exactly which dashboard setting to flip where it does not.
- (d) List every third-party script that fires on page load and remove the ones nothing uses.

## 2. Accessibility: keyboard and alt text
- Every interactive element (buttons, links, inputs, custom components with onClick) must be reachable and operable by keyboard: real `<button>`/`<a>`, a visible `:focus-visible` style (never `outline: none` without a replacement), logical tab order, Escape closes modals and returns focus.
- Every `<img>`, meaningful background image, icon button and SVG gets real alt text saying what it IS (`alt=""` only if purely decorative) and an `aria-label` on every icon-only button. Add a skip-to-content link.
- Run the accessibility linter that fits the stack (eslint-plugin-jsx-a11y, axe, pa11y) and fix what it reports.

## 3. Database: Row Level Security
Find the database layer (Supabase, Firebase, Prisma, Drizzle, raw SQL).
- Supabase: list every table in the migrations; enable RLS on every one; policies so a user can only select/insert/update/delete their own rows (`auth.uid() = user_id`), service-role-only access for everything else.
- Firebase: the same in firestore.rules / database.rules.
- Client code: the ANON/public key is fine in the browser, but grep for the SERVICE ROLE key, secret keys and admin credentials. They must never be in client bundles, `NEXT_PUBLIC_*`/`VITE_*` variables, or committed .env files. Move them server-side.
- Verify every API route reads the user from the SESSION, never from a user id in the request body or URL.

## 4. Messaging: consent before any text or email
Find every place the app sends SMS (Twilio, Vonage, MessageBird, AWS SNS) or bulk email (Resend, SendGrid, Postmark, Mailchimp, a loop over users).
- SMS: no marketing text without prior express WRITTEN consent. Add an unchecked-by-default opt-in checkbox on the form that collects the number, with copy saying what they will receive, how often, that consent is not a condition of purchase, and STOP to unsubscribe. Store the consent with a timestamp and the exact copy shown. Handle STOP/HELP replies. Never send marketing to a number without a stored consent record.
- Email: a working one-click unsubscribe in every commercial message, and a suppression list the send path checks.
- Rate-limit and dedupe every bulk send so one bug cannot send 10,000 twice.

## 5. Compute: nothing that can call itself, nothing without a cap
Find every serverless function, cron, queue consumer, webhook handler and background job (Cloud Run, Lambda, Vercel/Netlify functions, Supabase edge functions, Inngest, Trigger.dev). For each:
- (a) Check for recursion, retry loops and fan-out (a function that enqueues or invokes itself, a webhook that triggers the thing that fires the webhook, a crawler with no visited set, a retry with no maximum). Add a depth limit, a visited set and a max-attempts on every one.
- (b) Set concurrency and max-instances explicitly in config (Cloud Run max-instances, Lambda reserved concurrency, Vercel `maxDuration`), never the default 1000.
- (c) Add a timeout to every outbound call.
- (d) If a budget or spend cap can be expressed in config, add it, and tell the owner exactly where to set the hard cap in the console where it cannot. A budget ALERT is not a cap.

## Also check, and fix if found
- Any secret, API key or token in the client bundle, in git history, or in logs.
- Error responses that reveal whether an email exists ("no user found" vs "wrong password"): make them identical.
- Sign-out that only clears the cookie: invalidate the session server-side too.

## Output
For each numbered item, a short "Found / Changed / You still need to" block. Then the summary table. Keep going until every item is resolved or explicitly handed to the owner.

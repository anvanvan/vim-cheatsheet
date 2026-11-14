---
name: deploy
description: Updates the local vim-cheatsheet plugin install to the version that landed on origin/main. Fires on /deploy, 'ausliefern' or 'deploy' after a landing in vim-cheatsheet.
---

# /deploy: update the installed vim-cheatsheet plugin

A landing on `origin/main` publishes the plugin, because the GitHub repo `anvanvan/vim-cheatsheet` is its marketplace. This skill pulls that version into the user-scope install on this machine and proves the installed version matches `main`.

## Step 1. Pre-check

**Confirm that main carries a new version.** Run `git -C /Users/tuan/dev/vim-cheatsheet fetch origin main`, then `git -C /Users/tuan/dev/vim-cheatsheet show origin/main:.claude-plugin/plugin.json` and read `version`. Run `claude plugin list --json` and read `version` of `vim-cheatsheet@vim-cheatsheet`. Equal versions → report `nothing to deploy: <version> installed` and stop, except under `--dry-run`, which goes on to Step 2. The install only moves when `version` in `plugin.json` rises, so a landing without a version bump ships nothing.

## Step 2. Run the executor

**Spawn the agent `deploy-executor` in the foreground.** Pass `mode:run`, or `mode:dry-run` for `/deploy --dry-run`, and the expected version from Step 1. The project has one target, so there is no target question and no override.

## Step 3. Read the verdict

Read the returned block line by line.

- `DEPLOY: success` → report `DEPLOYED-REF` and `EVIDENCE` as shipped. Tell the user to restart the session, because `claude plugin update` applies only after a restart.
- `DEPLOY: half-deploy: <step>` or `DEPLOY: aborted-at-gate: <gate>` → report the failed step. It is not shipped.
- `DEPLOY: aborted: denied by classifier` → give the user the rules `Bash(claude plugin marketplace update:*)` and `Bash(claude plugin update:*)` for `/permissions` → Allow. Try nothing else.
- `DEPLOY: dry-run` → report the printed command lines.

**Reply:** the verdict line, `DEPLOYED-REF`, `EVIDENCE`, and the restart note on success.

---
status: open
---
# Trail: setup

## Ziel
> Repo für pr-gate einrichten (Antwort auf: Wie soll 0.1.1 auf GitHub kommen? — ein Hook sperrt den direkten Push auf main).

Land v0.1.1 (909be29, hint when vim mode is off) through pr-gate instead of a direct push, and set the repo up for the cycle tools.

## Route
- /setup-cycle: soll.toml → `.claude/cycle.toml` (gate test/main_test = full via `claude plugin validate --profile directory --strict . && claude plugin test .`, revert auto, trailers Co-Authored-By, scripts.language ruby).
- `.gitignore` dropped its `.claude/` line so `cycle.toml` and trails are tracked.
- qlty-baseline derive: eslint + semgrep + slop patterns (user: übernehmen); check 0 findings.
- create-deploy-skill: `.claude/skills/deploy/SKILL.md` + `.claude/agents/deploy-executor.md` (marketplace update + plugin update, evidence = `claude plugin list --json` version).
- Review stages skipped: empty project memory, no CLAUDE.md, no legacy hooks/agents.

## Proofs
- setup-cycle --apply: getan angelegt `.claude/cycle.toml`; get-toml reads gate.test=full, gate.main_test=full, gate.revert=auto, commit.trailers=Co-Authored-By.
- `/deploy --dry-run` in a fresh `claude -p`: `DEPLOY: dry-run`, install unchanged (0.1.0, lastUpdated 2026-11-13T05:38:51Z).
- CLAUDE.md moved to `.claude/CLAUDE.md`: at the plugin root the directory validator warns ("not loaded as project context"); sessions still read `Deploy: /deploy` there (claude -p probe).

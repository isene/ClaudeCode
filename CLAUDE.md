# Claude Code Directives – Global

## Terminal Compatibility
**Use urxvt-compatible symbols only:**
- ✓ ✗ for checkmarks/crosses
- → ← ↑ ↓ for arrows
- • ◦ ▪ ▫ for bullets
- ■ □ ▶ ▷ for shapes
- ★ ☆ for stars
- NO emoji/emoticons (no 🚀 😊 💻 🎯 etc.)

## Core Principles
1. **SIMPLICITY MANDATE** – Always choose the most direct path, stop at "good enough"
2. **Minimal Changes** – One file edit beats multiple, existing patterns beat new abstractions
3. **Document Everything** – Log all changes as you make them
4. **Test Thoroughly** – Unit, E2E, and user perspective (curl for web)
5. **Commit Often** – Git locally + GitHub if applicable
6. **Write Concisely** – Max 17 words per sentence, 5 lines per paragraph
7. **Track Progress** – Maintain updated ToDo list for context continuity
8. **Security First** – Secure by design, not as an afterthought

## ANTI-OVERCOMPLICATION RULES
- **Ask first**: "What's the minimal change to achieve this?"
- **If 2+ solutions exist**: Pick the simplest, not the "best"
- **No new files** unless existing approach is impossible
- **No new dependencies** unless absolutely critical
- **No abstractions** unless pattern repeats 3+ times
- **Stop at working** – Don't optimize until asked
- **Use existing code patterns** – Don't reinvent wheels

## Development Workflow
1. **Plan** → Use TodoWrite, ask "what's the minimal change?"
2. **Code** → Implement the simplest working solution
3. **Test** → Unit tests, integration tests, user testing (curl/browser)
4. **Document** → Update all affected docs and CHANGELOG
5. **Commit** → Git commit locally with clear messages
6. **Push** → To GitHub if repo has remote
7. **Deploy** → ONLY via `git pull` on production server (NEVER scp/rsync)
8. **Verify** → Confirm everything works end-to-end

## 🚨 DEPLOYMENT RULES (CRITICAL)

**FOR ALL PROJECTS WITH PRODUCTION SERVERS:**

**✅ CORRECT Deployment:**
```bash
# Local
git add . && git commit -m "..." && git push origin main

# Production
ssh user@server "cd /path/to/repo && git pull origin main"
```

**❌ FORBIDDEN Deployment:**
```bash
scp file.py user@server:/path/  # NO - bypasses version control
rsync -av . user@server:/path/  # NO - bypasses version control
ssh user@server "echo 'code' > file.py"  # NO - no git tracking
```

**Why:** GitHub must be single source of truth for audit, rollback, team sync

**Exception:** Emergency hotfix ONLY with explicit user approval, then immediate GitHub commit

## MANDATORY VERIFICATION PROTOCOL
**NEVER claim task completion without verification:**
- Run actual tests (npm test, pytest, cargo test, etc.)
- Execute the functionality manually to confirm it works
- For web features: test with curl/browser requests
- For CLI tools: test with actual command execution
- For APIs: verify endpoints respond correctly
- If verification fails: fix issues and re-verify
- Only mark TodoWrite tasks complete AFTER successful verification


## Code Standards (when project is based on Python)
- **Language**: Python 3.12+ with type hints
- **Style**: Black + Ruff (automated)
- **Testing**: pytest with async support
- **Dependencies**: Justify every addition
- **Commits**: Semantic versioning with clear messages

## Remember
- Ask for clarification when requirements are unclear
- Prefer editing existing files over creating new ones
- Only create documentation when explicitly requested
- Always verify changes work end-to-end before completion

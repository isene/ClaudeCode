# LovData Skill - Norwegian Law Research Assistant

## Description
Expert knowledge for researching Norwegian law using the Lovdata API. Access and search Norwegian legal texts including current laws (gjeldende lover), regulations (forskrifter), and legal gazette (Lovtidend).

## When to Activate
Activate when user asks about:
- Norwegian law, regulations, or legal requirements
- Specific Norwegian legal terms (personvern, straffeloven, arbeidsmiljøloven, etc.)
- Data protection and GDPR implementation in Norway
- Legal compliance for Norwegian operations
- Interpretation of Norwegian legislation

## Tools Available

### Location
All tools located in: `~/.claude/skills/lovdata/`

Scripts are self-contained Python files in the skill directory.

### Setup (First Time Only)

Create virtual environment and install dependencies:
```bash
cd ~/.claude/skills/lovdata
python3 -m venv venv
venv/bin/pip install -r requirements.txt
```

### Scripts

**lovdata.py** - List available law archives
```bash
cd ~/.claude/skills/lovdata
venv/bin/python lovdata.py list
```

Returns 4 available archives:
- gjeldende-sentrale-forskrifter.tar.bz2 (current regulations, ~20MB)
- gjeldende-lover.tar.bz2 (current laws, ~5.5MB)
- lovtidend-avd1-2025.tar.bz2 (2025 gazette, ~2.6MB)
- lovtidend-avd1-2001-2024.tar.bz2 (2001-2024 gazette, ~65MB)

**lovdata_search.py** - Search Norwegian law text
```bash
cd ~/.claude/skills/lovdata
venv/bin/python lovdata_search.py "<query>" [max_results]
```

Features:
- Downloads and caches archives locally
- Full-text search with regex support
- Extracts XML law documents
- Returns context around matches
- Saves results to JSON

## Search Strategy

### 1. Identify Norwegian Legal Terms
Common terms:
- personvern (privacy/data protection)
- personopplysning (personal data)
- straffeloven (criminal code)
- arbeidsmiljøloven (work environment act)
- forbruker (consumer)
- behandle (process/handle)
- oppholdstillatelse (residence permit)

### 2. Execute Search
```bash
cd ~/.claude/skills/lovdata
venv/bin/python lovdata_search.py "personopplysning" 10
```

### 3. Review Results
- Results printed to terminal with context
- Full details saved to `lovdata_search_results.json` in skill directory
- Archives cached in `./cache/` subdirectory

### 4. Analyze and Answer
- Read the JSON results file for detailed analysis
- Quote relevant law sections with file references
- Provide clear interpretation based on actual legal text

## Example Workflow

**User asks**: "What does Norwegian law say about data protection?"

**Steps**:
1. Search for "personopplysning" (personal data)
   ```bash
   cd ~/.claude/skills/lovdata
   venv/bin/python lovdata_search.py "personopplysning" 10
   ```

2. Search for "personvernforordningen" (GDPR reference)
   ```bash
   cd ~/.claude/skills/lovdata
   venv/bin/python lovdata_search.py "personvernforordningen" 10
   ```

3. Read results JSON file
   ```bash
   cat ~/.claude/skills/lovdata/lovdata_search_results.json
   ```

4. Analyze findings and provide answer with:
   - Specific law sections found
   - File references (e.g., nl/nl-19990702-063.xml)
   - Context quotes from actual legal text
   - Clear interpretation

## Important Notes

### Norwegian Legal References
- "personvernforordningen" = GDPR (EU regulation incorporated into Norwegian law)
- Laws reference GDPR articles (artikkel 9, 10, etc.) for data protection
- Norway implements EU/EEA regulations through incorporation

### Search Tips
- Use Norwegian terms, not English translations
- Try multiple related terms for comprehensive results
- Use regex for flexible matching: "personvern.*behandling"
- Start with current laws archive (gjeldende-lover.tar.bz2)

### Result Interpretation
- XML files contain structured legal documents
- Multiple laws may reference same concepts
- Cross-reference results for complete picture
- Note law numbers (nl/nl-YYYYMMDD-NNN.xml format)

## Technical Details

### Cache Management
- Archives cached in `~/.claude/skills/lovdata/cache/`
- Reused across searches for performance
- Delete cache to force fresh download

### Virtual Environment
- All scripts run in venv: `venv/bin/python`
- Dependencies: httpx (HTTP client)
- Python 3.12+ with async support
- Setup once per skill installation

### Output Files
- `lovdata_archives.json` - Archive listing (in skill directory)
- `lovdata_search_results.json` - Latest search results (in skill directory)
- Both use UTF-8 encoding with Norwegian characters

## Data Source
All data from official Lovdata API: https://api.lovdata.no
Public endpoints, no authentication required for basic access.

## Response Format

When answering legal questions:
1. State which searches were performed
2. Quote relevant law sections with file references
3. Provide context from actual legal text
4. Explain interpretation clearly
5. Note if results are from current laws vs historical gazette
6. Mention if GDPR/EU regulations are referenced

## Limitations

- Searches current laws only (unless other archives specified)
- Text extraction from XML may lose formatting
- Legal interpretation should note this is automated research
- Complex legal questions may require professional legal advice
- Archive updates lag behind latest law changes by days

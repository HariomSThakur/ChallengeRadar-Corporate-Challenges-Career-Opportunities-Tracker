# Corporate Challenge Tracker

A small Windows Python project that searches public web index results for company challenges, hackathons, competitions, and recruitment-linked opportunities. Company names, search domains, and keywords are editable without changing the code.

## Project files

- `companies.csv` — companies, search aliases, official websites, and categories.
- `sources.json` — LinkedIn, X, Instagram, Facebook, Threads, YouTube, Unstop, Naukri, HackerEarth, Devpost, GitHub, India, language, and recentness settings.
- `keywords.json` — primary and recruitment terms plus certificate and hiring evidence terms.
- `tracker.py` — performs searches, matches the configured terms, remembers results in SQLite, and writes Markdown reports.
- `setup_daily_task.ps1` — creates a Windows Task Scheduler entry for 9:00 AM.
- `remove_daily_task.ps1` — removes that scheduled task.

## Setup

1. Install Python 3.10 or newer.
2. Open PowerShell in this folder and copy `.env.example` to `.env`.
3. Run `python tracker.py --dry-run` to check the configuration and preview a search without using the network or API keys.
4. When ready to search, get a Brave Search API key and put it in `.env` as `BRAVE_SEARCH_API_KEY=...`.
5. Run a manual search with `python tracker.py` and review `reports/latest.md`. The first run can surface older indexed pages; the SQLite database suppresses unchanged repeats on later runs.
6. To schedule daily searches, run `.\setup_daily_task.ps1` from PowerShell after a manual search works. The task uses the current Windows account and runs at 9:00 AM local time while you are signed in.

## Optional AI evidence review

To enable OpenAI review, add an API key to `.env` and set `ENABLE_AI_ANALYSIS=true`. This can incur API charges. It is off by default, so a Brave key alone will not trigger AI calls. You can optionally change `OPENAI_MODEL` or `AI_MAX_PER_RUN`. The model receives only the search result title and snippet, and returns a structured assessment of opportunity type, eligibility, deadline, and hiring evidence. AI requests are limited by `AI_MAX_PER_RUN`. Without AI, the report clearly labels its assessment as keyword-based.

The tracker distinguishes a stated recruitment pathway, certificate-only wording, no hiring evidence visible in the snippet, and unclear evidence. A search result is not proof of a job offer or an authentic announcement; open the source link before relying on it.

## Search coverage and limits

This first version queries a web search API over the domains in `sources.json` and each company's official website domain. It does not log in to social platforms, bypass access controls, or scrape private pages. Search engines may not index every social post, and results can be delayed or incomplete. Platform APIs require separate access and may restrict which posts an app can retrieve. Treat this as a public-source discovery tool, not a complete social-media archive.

`freshness` in `sources.json` accepts Brave's recentness values (`pd`, `pw`, `pm`, `py`) or an empty string for no date filter. It defaults to the past month so a challenge posted several weeks before its deadline can still be discovered. `results_per_query` controls how many results are requested for each query. Search API account limits and costs are set by the provider.

## Report and stored data

- Reports are written to `reports/YYYY-MM-DD.md` and `reports/latest.md`.
- Deduplication data is stored in `data/tracker.sqlite3`.
- `.env`, reports, and the database are excluded from Git by `.gitignore`.

The report includes new or changed matching results only. If a result disappears and later returns with the same title and snippet, it remains suppressed. If a page's title or snippet changes, it is reported as updated.

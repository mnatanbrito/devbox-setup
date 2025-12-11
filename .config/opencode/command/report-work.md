---
description: Generates a summary of the work I have done.
agent: general
---

This command generates a report of work done. Parameters:

- $1: Start date in format "MMM DD" (optional, defaults to 2 weeks ago)
- $2: End date in format "MMM DD" (optional, defaults to today)

To generate the report:

1. Get the currently logged in GitHub user using: `gh api user --jq .login`
2. Use the `gh` CLI to search for commits authored by the current user: `gh search commits --author=<username> --sort=author-date --order=desc --limit=100 --json id,commit,repository,url`
3. Parse the date parameters:
   - If no start date provided, default to 2 weeks ago from today
   - If no end date provided, default to today
   - Convert "MMM DD" format to a comparable date (use current year, or previous year if the date would be in the future)
4. Filter commits by the date range specified (where `commit.author.date` is between start and end dates)
5. Group commits by date (using `commit.author.date` date, formatted as "MMM DD")
6. Categorize each commit based on its message:
   - [Feature] - messages containing: feat, feature, add, implement, new
   - [Fix] - messages containing: fix, bug, resolve, patch, hotfix
   - [Refactor] - messages containing: refactor, cleanup, improve, optimize, reorganize
   - [Docs] - messages containing: doc, documentation, readme
   - [Chore] - messages containing: chore, deps, dependencies, update, upgrade, maintenance
   - [Other] - anything else
   - Use case-insensitive matching
7. Generate a summary in the specified format below

The report should follow this format:

```
- Month Name (e.g., Dec)
  - Month Day (e.g., Dec 11)
    - [Category] Brief description of the work
      - PR link
    - [Category] Another work item
      - PR link
  - Month Day (e.g., Dec 10)
    - [Category] Work description
      - PR link
```

Example output:

```
- Dec
  - Dec 11
    - [Feature] Add user authentication with OAuth2
      - https://github.com/org/repo/pull/123
    - [Fix] Resolve memory leak in cache manager
      - https://github.com/org/repo/pull/124
  - Dec 10
    - [Refactor] Improve database query performance
      - https://github.com/org/repo/pull/125
```

The following are the expected usage cases for the command:

- `/report-work`: Generates a report for the past 2 weeks.
- `/report-work "Nov 15"`: Generates a report since Nov 15 to today.
- `/report-work "Nov 15" "Dec 5"`: Generates a report from Nov 15 to Dec 5.

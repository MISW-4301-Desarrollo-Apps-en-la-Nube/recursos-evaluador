# Course Setup Scripts

This directory contains scripts to automate the setup of GitHub organizations, teams, and repositories for course management.

## Prerequisites

### Required Software

1. **Node.js** (v14 or higher)
   - Check if installed: `node --version`
   - Download from: [https://nodejs.org/](https://nodejs.org/)

2. **npm** (comes with Node.js)
   - Check if installed: `npm --version`

### Required Environment Variables

Create a `.env` file in this directory with the following variables:

```env
GITHUB_TOKEN=your_github_personal_access_token
GITHUB_ORG=your_github_organization_name
TEAM_COUNT=number_of_teams
COLLEGE_PERIOD=period_identifier
TEMPLATE_REPO=template_repository_name
```

**Getting a GitHub Token:**
1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate a new token with the following permissions:
   - `admin:org` (for managing teams and repositories)
   - `repo` (for repository management)
3. Copy the token and add it to your `.env` file

## Installation

1. Install dependencies:
   ```bash
   npm install
   ```

This will install:
- `@octokit/rest` - GitHub API client
- `dotenv` - Environment variable management

## Scripts

### 1. Create Teams (`create-teams.js`)

Creates GitHub teams for student groups in your organization.

**Usage:**
```bash
node create-teams.js
```

**What it does:**
- Creates teams with names following the pattern: `{COLLEGE_PERIOD}-grupo1`, `{COLLEGE_PERIOD}-grupo2`, etc.
- Teams are created as "secret" (private)
- If a team already exists, it will skip with a warning

**Required Environment Variables:**
- `GITHUB_TOKEN`
- `GITHUB_ORG`
- `TEAM_COUNT`
- `COLLEGE_PERIOD`

---

### 2. Create Repositories from Template (`create-repos-from-template.js`)

Creates private repositories for each team from a template repository.

**Usage:**
```bash
node create-repos-from-template.js
```

**What it does:**
- Creates repositories named: `{COLLEGE_PERIOD}-grupo{number}-proyecto`
- Each repository is created from the specified template
- Assigns each repository to its corresponding team with "maintain" permissions
- If a repository already exists, it will skip with a warning

**Required Environment Variables:**
- `GITHUB_TOKEN`
- `GITHUB_ORG`
- `TEAM_COUNT`
- `COLLEGE_PERIOD`
- `TEMPLATE_REPO`

**Note:** Run `create-teams.js` first before running this script.

---

### 3. Setup Monitor Access (`setup-monitor-access.js`)

Sets up access for tutors/monitors to all student repositories.

**Usage:**
```bash
node setup-monitor-access.js
```

**What it does:**
- Creates a team named `Tutores-Native` (if it doesn't exist)
- Grants "maintain" permissions to this team for all student repositories
- If the team or repositories already exist, it will skip with appropriate warnings

**Required Environment Variables:**
- `GITHUB_TOKEN`
- `GITHUB_ORG`
- `TEAM_COUNT`
- `COLLEGE_PERIOD`

**Note:** Run `create-teams.js` and `create-repos-from-template.js` first before running this script.

---

## Recommended Execution Order

Run the scripts in the following order:

1. **Create Teams:**
   ```bash
   node create-teams.js
   ```

2. **Create Repositories:**
   ```bash
   node create-repos-from-template.js
   ```

3. **Setup Monitor Access:**
   ```bash
   node setup-monitor-access.js
   ```

## Troubleshooting

- **"Team already exists" / "Repo already exists"**: These warnings are safe to ignore. The script will continue processing other items.

- **"401 Unauthorized"**: Check that your `GITHUB_TOKEN` is valid and has the correct permissions.

- **"404 Not Found"**: Verify that:
  - The `GITHUB_ORG` value matches your organization name exactly
  - The `TEMPLATE_REPO` exists in your organization
  - Your token has access to the organization

- **"422 Unprocessable Entity"**: Usually means the resource already exists or there's a validation error. Check the error message for details.

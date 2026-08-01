import 'dotenv/config';
import { Octokit } from '@octokit/rest';

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN,
});

const NUMBER_OF_TEAMS = parseInt(process.env.TEAM_COUNT);
const COLLEGE_PERIOD = process.env.COLLEGE_PERIOD;

const teams = Array.from(
  { length: NUMBER_OF_TEAMS },
  (_, i) => `${COLLEGE_PERIOD}-grupo${i + 1}`
);

async function createRepos() {
  for (const team of teams) {
    const repoName = `${team}-proyecto`;

    try {
      // 1. Crear repo desde template
      await octokit.rest.repos.createUsingTemplate({
        template_owner: process.env.GITHUB_ORG,
        template_repo: process.env.TEMPLATE_REPO,
        owner: process.env.GITHUB_ORG,
        name: repoName,
        private: true,
      });

      console.log(`✅ Repo creado: ${repoName}`);

      // 2. Asignar repo al team con permiso READ
      await octokit.rest.teams.addOrUpdateRepoPermissionsInOrg({
        org: process.env.GITHUB_ORG,
        team_slug: team,
        owner: process.env.GITHUB_ORG,
        repo: repoName,
        permission: 'maintain', 
      });

      console.log(`👥 Repo ${repoName} agregado al team ${team}`);

    } catch (error) {
      if (error.status === 422) {
        console.log(`⚠️ Repo ya existe: ${repoName}`, error.message);
      } else {
        console.error(`❌ Error con ${repoName}:`, error.message);
      }
    }
  }
}

createRepos();

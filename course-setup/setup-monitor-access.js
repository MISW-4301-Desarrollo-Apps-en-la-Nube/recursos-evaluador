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

const MONITOR_TEAM_NAME = 'Tutores-Native';

async function setupMonitorAccess() {
  try {
    await octokit.rest.teams.create({
      org: process.env.GITHUB_ORG,
      name: MONITOR_TEAM_NAME,
      privacy: "visible",
    });
    console.log(`✅ Team monitor creado`);
  } catch (error) {
    if (error.status === 422) {
      console.log(`⚠️ Team monitor ya existe`);
    } else {
      console.error(`❌ Error creando team monitor`, error.message);
    }
  }

  // Darle permiso sobre todos los repos de estudiantes
  for (const team of teams) {
    const repoName = `${team}-proyecto`;

    try {
      await octokit.rest.teams.addOrUpdateRepoPermissionsInOrg({
        org: process.env.GITHUB_ORG,
        team_slug: MONITOR_TEAM_NAME,
        owner: process.env.GITHUB_ORG,
        repo: repoName,
        permission: 'maintain',
      });

      console.log(`👥 Repo ${repoName} agregado al team monitor`);

    } catch (error) {
      if (error.status === 422) {
        console.log(`⚠️ Repo ya existe: ${repoName}`, error.message);
      } else {
        console.error(`❌ Error con ${repoName}:`, error.message);
      }
    }
  }
}

setupMonitorAccess();

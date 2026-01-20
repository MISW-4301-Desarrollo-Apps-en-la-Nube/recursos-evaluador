import { Octokit } from "@octokit/rest";
import 'dotenv/config';

const octokit = new Octokit({
  auth: process.env.GITHUB_TOKEN, // export GITHUB_TOKEN=xxx
});

const NUMBER_OF_TEAMS = parseInt(process.env.TEAM_COUNT);
const COLLEGE_PERIOD = process.env.COLLEGE_PERIOD;

const teams = Array.from(
  { length: NUMBER_OF_TEAMS },
  (_, i) => `${COLLEGE_PERIOD}-grupo${i+1}`
);

async function createTeams() {
  console.log('⚒️ Empezando a crear teams...');
  for (const name of teams) {
    try {
      await octokit.rest.teams.create({
        org: process.env.GITHUB_ORG,
        name,
        privacy: "secret",
      });
      console.log(`✅ Team creado: ${name}`);
    } catch (error) {
      if (error.status === 422) {
        console.log(`⚠️ Team ya existe: ${name}`);
      } else {
        console.error(`❌ Error creando ${name}`, error.message);
      }
    }
  }
  console.log('⚒️ Termine de crear teams');
}

createTeams();

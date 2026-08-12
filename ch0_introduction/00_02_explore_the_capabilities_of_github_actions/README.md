# 00_02 Explore the Capabilities of Github actions

## An Overview of CI/CD

| Stage | Description | Automation Focus | Primary Goal |
| ----- | ----------- | ---------------- | ------------ |
| **Continuous Integration (CI)** | Developers frequently commit code to a shared repository. New changes are merged with existing code and automatically checked using linting and unit tests. | Code validation and fast feedback | Catch errors early and keep the codebase stable |
| **Continuous Delivery (CD)** | After successful integration, the build process is automated. Additional, higher-level tests run and the application is packaged for release. | Build, test, and package automation | Always have software that is ready to deploy |
| **Continuous Deployment (CD)**  | Every change that passes validation is automatically deployed to production with no manual intervention. | End-to-end pipeline automation | Release software quickly and reliably |

## Terminology

|Keyword|Definition|
|-------|----------|
| **Workflows**|Workflows define how all the automation in a process is tied together including how the process gets started.  Files are written using YAML and must be stored in the `.github/workflows` directory at the root of the repo.|
| **Events**|Events are the triggers that start a workflow. Common events are `push`, `workflow_dispatch`, and `pull_request`.|
| **Runners**|Runners define the compute layer where jobs are executed.  GitHub Actions provides runners with popular operating systems like Ubuntu, Windows, and macOS.|
| **Jobs**|Each workflow contains one or more jobs.  Jobs are high-level tasks that define one or more steps that need to be run for the job to complete.|
| **Steps**|The actual work done by a job takes place in Steps.  Steps are simple commands, shell scripts, or they can be Actions.|
|**Actions**|Actions help speed up your workflow development by bundling programs, runtimes, and all of their dependencies into Docker containers or JavaScript modules.|

## References

| Reference | Description |
|----------|-------------|
| [Learning GitHub Actions: Event-Driven Automation for Your Codebase](https://www.linkedin.com/learning/learning-github-actions-event-driven-automation-for-your-codebase/) | Comprehensive LinkedIn Learning course covering event-driven automation fundamentals and practical GitHub Actions implementation |
| [What is CI/CD?](./CI_CD.md) | Another brief overview of CI/CD |
| [Quickstart for GitHub Actions](https://docs.github.com/en/actions/quickstart) | Official GitHub documentation providing a fast-track introduction to creating and running your first GitHub Actions workflow |
| [Using workflows](https://docs.github.com/en/actions/using-workflows) | In-depth official guide to understanding workflow syntax, configuration, and best practices for GitHub Actions |
| [GitHub Marketplace: Actions](https://github.com/marketplace?type=actions) | Curated marketplace of pre-built actions created by GitHub and the community to extend your workflow capabilities |
| [GitHub Actions Runner Images](https://github.com/actions/runner-images/tree/main) | Repository containing configuration details and available software for GitHub-hosted runner environments |

## Review a GitHub Actions Workflow

Review the following workflow and look for how events, runners, jobs, and steps are defined in YAML.

```yaml
name: GitHub Actions Workflow

on:
  push:
  pull_request:
  workflow_dispatch:

jobs:
  integration:
    name: Lint and Test
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Show runner info
        run: |
          echo "Actor: $GITHUB_ACTOR"
          echo "Repo:  $GITHUB_REPOSITORY"
          echo "SHA:   $GITHUB_SHA"
          uname -a
          ls -la

      - name: Show runner environment
        run: set
```

You can also [follow this link to view the workflow file](./github-actions-workflow.yaml).

<!-- FooterStart -->
---
[← 00_01 Extra Content 02: Using Exercise Files From the Course](../00_01_xtra_02_using_exercise_files/README.md) | [00_03 Software Versions →](../00_03_software_versions/README.md)
<!-- FooterEnd -->

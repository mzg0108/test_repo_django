# 02_05 Solution: Develop a Container Image Workflow

In this challenge, you’ll create a **continuous delivery workflow** that builds and publishes a **container image** for a Python application using **GitHub Actions**. Starting from a brand-new repository, you’ll add application files, configure an integration workflow, and connect it to a delivery workflow that publishes a Docker image to GitHub Packages.

By the end of this challenge, you’ll have hands-on experience with reusable workflows, workflow dependencies, and delivery pipelines.

## Challenge tasks

To complete this challenge, you will:

- Create a new GitHub repository for a Python project
- Upload application files and a Dockerfile
- Configure a Python integration workflow using a starter template
- Update the workflow to use a `workflow_call` trigger
- Configure a container delivery workflow using a starter template
- Connect the integration and delivery workflows
- Configure job permissions and job dependencies
- Run the workflow and verify that a container image is published

This challenge should take 15 to 20 minutes to complete.

## Prerequisites

Before you begin, make sure you have:

- The exercise files for this lesson downloaded locally

## Instructions

### Step 1: Create a New GitHub Repository

1. Log in to your GitHub account.
2. Create a **new repository**.
3. Enter the repository name: `container-image-workflow`.
4. Add a description such as "A workflow that sets up a CI and delivery pipeline for a Python project containing a Dockerfile".
5. Set the repository visibility to **Public**.
6. Select **Add a README file**.
7. Choose **Python** for the `.gitignore`.
8. Select **Create repository**.

### Step 2: Upload the Exercise Files

1. From the repository page, select **Add file → Upload files**.
2. Select **Choose your files**.
3. Browse to the folder containing the exercise files.
4. Select **all files** (including the Dockerfile).
5. Select **Open**, then **Commit changes**.

Verify that the repository now contains:

- Python application files
- A `Dockerfile` at the repository root

### Step 3: Create the Integration Workflow Using a Starter Template

1. Select the **Actions** tab.
2. Because no workflows exist yet, GitHub will suggest starter workflows.
3. Locate the **Python application** workflow.
4. Select **Configure**.

### Step 4: Update the Integration Workflow Trigger

In the workflow file:

1. Remove the existing triggers:

    - `push`
    - `pull_request`

2. Add a `workflow_call` trigger so the workflow can be reused by other workflows.
3. Update GitHub Action versions to the latest available versions:

    - `actions/checkout`
    - `actions/setup-python`

4. Leave the remaining steps unchanged.
5. Commit the workflow **directly to the `main` branch**.

### Step 5: Create the Container Delivery Workflow

1. Return to the **Actions** tab.
2. Select **New workflow**.
3. Scroll to the **Continuous integration** section.
4. Locate **Publish Docker container**.
5. Select **Configure**.

### Step 6: Add the Integration Job to the Delivery Workflow

1. Add a new job named `integration`.
2. Configure the job to use the integration workflow created earlier, reference the integration workflow file path: `uses: ./.github/workflows/python-app.yml`.
3. Add permissions block that allows the integration job to:

   - Read repository contents: `contents: read`
   - Write checks: `checks: write`

### Step 7: Create a Job Dependency

1. Locate the `build` job in the delivery workflow.
2. Add a dependency so the build job only runs after integration completes successfully: `needs: integration`.
3. Update all GitHub Actions in the workflow to their latest versions.
4. Commit the workflow directly to the `main` branch.

### Step 8: Observe the Workflow Execution

1. Because the container workflow includes a `push` trigger, a workflow run should start automatically.
2. Navigate to the **Actions** tab.
3. Open the running workflow.
4. Confirm:

    - The `integration` job runs first
    - The `build` job waits for integration to complete

### Step 9: Verify the Published Container Image

1. Return to the repository homepage.
2. Locate the **Packages** section on the right-hand side.
3. Select the newly created container package.
4. Confirm:

    - The image build completed successfully
    - The image was pushed to GitHub Packages

## Challenge Completion

1. Review the tasks in this challenge.
2. Consider how the steps mirror a real-world continuous delivery workflow.
3. Consider how GitHub Packages can be used as a delivery target for container images.

### Optional Reflection

1. Why is it beneficial to separate integration and delivery workflows?
2. How does `workflow_call` improve reuse and consistency across pipelines?
3. How might you extend this workflow to push to an external container registry?

When you’re ready, move on to the next chapter!

<!-- FooterStart -->
---
[← 02_04 Challenge: Develop a Container Image Workflow](../02_04_challenge_container_workflow/README.md) | [03_01 Deploying Software with Github actions →](../../ch3_deployment/03_01_deploying_software_with_github_actions/README.md)
<!-- FooterEnd -->

# 01_01 Leverage Starter Workflows

What Are Starter Workflows?

- Pre-built workflow templates provided by **GitHub Actions**
- Let you create a working CI pipeline in minutes
- Designed to be **starting points**, not final solutions

**Primary Benefit**: Get from “no automation” to “working CI” fast.

## How GitHub Suggests Starter Workflows

GitHub analyzes your repository and recommends workflows based on what it finds.

### Language & File Detection

- File extensions (e.g., `.py`, `.js`, `.go`)
- Dependency files (e.g., `requirements.txt`, `Pipfile.lock`, `package.json`)

### Frameworks & Tooling

- Build tools (`Makefile`)
- Containers (`Dockerfile`)
- Infrastructure (`*.tf` for Terraform)

**Result**: GitHub suggests workflows that match how your project is built, tested, or deployed.

## Common Starter Workflow Structure

Most starter workflows follow the same high-level outline.

### 1. Triggers

- Defines **when** the workflow runs
- Common triggers:

  - `push`
  - `pull_request`
  - `workflow_dispatch`

- Often scoped to specific branches

### 2. Permissions

- Declares what the workflow can do with the `GITHUB_TOKEN`
- Applies to:

  - API access
  - Writing results, annotations, or reports

### 3. Jobs & Runners

- Defines:

  - One or more jobs
  - The runner environment (Linux, Windows, macOS)

- Determines **where** the workflow executes

### 4. Steps

- Ordered list of actions and commands
- This is where the actual work happens

## Typical Step Pattern

Starter workflows usually include these steps in order:

### 1. Check Out Code

- Pulls repository contents onto the runner
- Required for almost all workflows

### 2. Set Up Environment

- Install language runtimes (e.g., Python, Node.js)
- Install dependencies and libraries
- Prepare the project to run

### 3. Run Project Commands

- Linting
- Tests
- Builds
- Artifact generation

## Improving Starter Workflows

Starter workflows work out of the box—but small changes make them much better.

### 1. Review Permissions

- Some steps need **write** permissions
- Common use cases:

  - Test reports
  - Annotations
  - Status summaries

### 2. Update Action Versions

- Starter templates may reference older versions
- Check action releases and update as needed
- Reduces warnings and deprecated behavior

### 3. Add Artifacts & Reporting

- Save logs, test reports, or build outputs
- Makes debugging failures much easier
- Improves visibility into workflow results

## Key Takeaway

- Starter workflows help you move fast
- Understanding the structure lets you:

  - Customize safely
  - Avoid common pitfalls
  - Build reliable CI pipelines

**Next**: Use starter workflows to build your first continuous integration pipelines.

<!-- FooterStart -->
---
[← 00_03 Software Versions](../../ch0_introduction/00_03_software_versions/README.md) | [01_02 Set Up CI for Javascript →](../01_02_ci_for_javascript/README.md)
<!-- FooterEnd -->

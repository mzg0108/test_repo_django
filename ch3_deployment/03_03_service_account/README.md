# 03_03 Create a Service account for Deployments

When deploying to platforms outside of GitHub, workflows need a secure way to authenticate and access external services.

A **service account** provides this access. It isn’t tied to a specific person; instead, it represents an identity that GitHub Actions uses to deploy artifacts on our behalf.

Service accounts are granted **only the permissions required for deployment**, reducing risk and preventing access to unnecessary services.

To use a service account:

- Credentials are created and scoped to the required permissions
- Those credentials are stored securely as encrypted secrets
- Workflows access the credentials at runtime to authenticate and deploy

This course will use **Amazon Web Services (AWS)** as the deployment target.
AWS offers a free tier that allows you to deploy applications at no cost for a limited time, making it ideal for hands-on learning.

> [!TIP]
> If you don’t already have one, I encourage you to create your own, personal AWS account that you can use to follow along.

## References

| Reference | Description |
|----------|-------------|
| [Free Cloud Computing Services - AWS Free Tier](https://aws.amazon.com/free/) | AWS Free Tier information for cloud computing services |
| [OpenID Connect (OIDC)](https://docs.github.com/en/actions/concepts/security/openid-connect) | GitHub Actions documentation for using OpenID Connect for secure authentication |

## Lab: Provision a Service Account and Deployment Targets; Configure GitHub Actions for AWS Deployments

In this lab, you will:

1. Deploy a CloudFormation stack that creates:

   - A service account (IAM role for GitHub Actions)
   - Lambda functions representing staging and production environments

2. Configure GitHub repository and environment variables using the CloudFormation outputs

These steps prepare your repository so GitHub Actions can [authenticate with AWS using OIDC](https://docs.github.com/en/actions/concepts/security/openid-connect) during the deployment.

### Part 1: Deploy the CloudFormation Stack

1. Log in to your AWS account and navigate to the **CloudFormation** console.
2. Select **Create stack**.
3. Choose **Upload a template file**, then select **Choose file**.
4. Upload the CloudFormation template provided in the exercise files:

   - `service-account-cloudformation-template.yml`

5. Select **Next**.
6. Enter a stack name.  ie:

   - `lambda-application-stack`

7. Enter the GitHub repository name where your code will live.

   - Use the format:

     ```bash
     GITHUB_USER_NAME/GITHUB_REPO_NAME
     ```

     Example:

     ```bash
     automate6500/lambda-application
     ```

   > ⚠️ This value is critical.
   > If deployments fail later, this is the first setting to verify.

8. Select **Next**.
9. On the **Stack options** page, keep all defaults and scroll to the bottom.
10. Acknowledge that CloudFormation may create IAM resources.
11. Select **Next**, review the configuration, then select **Submit**.
12. Wait for the stack to complete successfully.
13. Once complete, open the **Outputs** tab.

You’ll use these output values in the next section, so keep this page open.

### Part 2: Configure GitHub Environments and Variables

#### 2.1 Create the Staging Environment

1. Return to the **Environments** page.
2. Select **New environment**.
3. Name the environment:

   ```bash
   Staging
   ```

   > ⚠️ Name the environment **Staging** with a capital **S**
   > If deployments fail later, check this setting.

4. Select **Configure environment**.
5. Scroll to **Environment variables** and select **Add environment variable**.
6. Add the following variable:

   - **Name:** `FUNCTION_NAME`
   - **Value:** Copy the value from the CloudFormation output
     `StagingFunctionName`

7. Select **Add variable**.
8. Add another environment variable:

   - **Name:** `URL`
   - **Value:** Copy the link address from the CloudFormation output
     `StagingURL`

9. Select **Add variable**.

#### 2.2 Create the Production Environment

1. Open your GitHub repository in a new browser tab.
2. Select **Settings**.
3. Select **Environments**.
4. Select **New environment**.
5. Name the environment:

   ```bash
   Production
   ```

   > ⚠️ Name the environment **Production** with a capital **P**
   > If deployments fail later, check this setting.

6. Select **Configure environment**.
7. Add the **Deployment protection rule**. Check the box next to **Required reviewers**
8. Search for and select your GitHub username as a reviewer.
9. Select **Save protection rules**
10. Scroll to **Environment variables** and select **Add environment variable**.
11. Add the following variable:

     - **Name:** `FUNCTION_NAME`
     - **Value:** Copy the value from the CloudFormation output
     `ProductionFunctionName`

12. Select **Add variable**.
13. Add another environment variable:

    - **Name:** `URL`
    - **Value:** Copy the link address from the CloudFormation output
      `ProductionURL`

14. Select **Add variable**.

Both environments are now configured with environment-specific values.

### Part 3: Add Repository-Level Variables

Some variables are shared across all environments and should be added at the repository level.

1. From the repository **Settings** page, select **Secrets and variables**, then **Actions**.
2. Select the **Variables** tab.
3. Select **New repository variable**.
4. Add the following variable:

   - **Name:** `AWS_REGION`
   - **Value:** The AWS region where your CloudFormation stack was deployed

5. Select **Add variable**.
6. Select **New repository variable** again.
7. Add the following variable:

   - **Name:** `AWS_ROLE_ARN`
   - **Value:** Copy the value from the CloudFormation output for the GitHub Actions role ARN

8. Select **Add variable**.

### Lab Complete

After completing the steps for this lab, you should have:

- Deployed the AWS resources needed for deployment
- Configured staging and production environments in GitHub
- Configured repository variables for all environments to access

In the next step, you’ll add the application code to the repository and use GitHub Actions to deploy the Lambda functions.

<!-- FooterStart -->
---
[← 03_02 Continuous Deployment for Github Pages](../03_02_cd_for_github_pages/README.md) | [03_04 Continuous Deployment for Lambda Functions →](../03_04_cd_for_lambda/README.md)
<!-- FooterEnd -->

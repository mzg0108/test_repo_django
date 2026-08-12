# https://github.com/aws-cloudformation/cfn-lint
# https://github.com/aws-cloudformation/rain

lint:
	cfn-lint github-oidc-cloudformation-template.yml
	rain fmt --verify github-oidc-cloudformation-template.yml
	cfn-lint service-account-cloudformation-template.yml
	#rain fmt --verify service-account-cloudformation-template.yml

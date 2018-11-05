## Requirements
* terraform version = 0.11.6
* active AWS IAM Access Keys

## Running templates
export AWS_ACCESS_KEY_ID=an-access-key<br/>
export AWS_SECRET_ACCESS_KEY=a-secret-key<br/>
export AWS_DEFAULT_REGION=an-aws-region<br/>
terraform get<br/>
terraform init<br/>
terraform plan<br/>
terraform apply<br/>

## Image built from
* https://github.com/kuldeep-surendra/packer_rails
* image_id in main.tf ami-0dc2e304f67060308(private ami built using packer, which should be changed) is used, which contains ruby dependencies installed using packer.

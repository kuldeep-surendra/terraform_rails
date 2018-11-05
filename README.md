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

* image_id in main.tf ami-0dc2e304f67060308 is used, which contains ruby dependencies installed using packer, which can be changed  *
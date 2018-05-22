# Steps to initialize on GCE

1. Create an account on GCE, and create a credentials.json file in this
directory using this information
https://www.terraform.io/docs/providers/google/index.html#authentication-json-file

2. Create a project name on GCE and amend main.tf with this name
https://cloud.google.com/resource-manager/docs/creating-managing-projects

3. Create a network on GCE and amend network.tf and main.tf with this name
https://cloud.google.com/vpc/docs/using-vpc

4. Note that the instance resources, region, etc can be edited directly in
main.tf

5. Initialize the instance locally via terraform

`terraform init`

`terraform apply`

6. To destroy the instance:

`terraform destroy`

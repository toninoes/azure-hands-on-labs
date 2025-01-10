# azure-hands-on-labs
Some hands-on labs done with Terraform.

## Instructions to deploy labs
You will need 2 inputs

- Credentials of Azure portal
- Subscription-id: Once you've logged-in in Azure portal we can get in [Subscriptions](https://portal.azure.com/#view/Microsoft_Azure_Billing/SubscriptionsBladeV2) section.
- Resource Group Name: We assume that there is already a resource group created for these labs.

### Get credentials
Run the following command:

```bash
export ARM_SUBSCRIPTION_ID="YOUR_ARM_SUBSCRIPTION_ID" && az login --username 'YOUR_USERNAME' --password 'YOUR_PASSWORD'
```

### Terraform 
Tipical Terraform workflow

#### Init
To initialize a working directory containing Terraform configuration files:

1. Downloads Provider Plugins: Terraform installs the necessary provider plugins mentioned in our configuration. Providers 
are responsible for understanding API interactions and exposing resources.
2. Sets Up the Backend: If you have specified a backend (for storing the state file), terraform init configures and initializes 
this backend. The state file tracks the state of our infrastructure.
3. Prepares the Environment: It sets up any additional configurations and requirements specified in our configuration files 
or environment.

```hcl
TF_WORKSPACE=sandbox terraform init
```

Adding `TF_WORKSPACE=sandbox` we'll create a new workspace called `sandbox`.

```hcl
terraform workspace list           
* default
  sandbox
```

#### Plan
To create an execution plan for our Terraform configuration files:

1. Analyzes the Configuration: Terraform reads the configuration files and determines what actions are necessary to achieve 
the desired state defined in those files.
2. Compares State: It compares the current state of our infrastructure with the desired state specified in our configuration.
3. Outputs Changes: It generates an execution plan that outlines the actions Terraform will take to achieve the desired state. 
This includes creating, modifying, or destroying resources.

```hcl
TF_WORKSPACE=sandbox terraform plan -var-file=sandbox.tfvars
var.resource_group_name
  Resource group where to deploy.

  Enter a value: YOUR_RESOURCE_GROUP_HERE
```

#### Apply
To apply the changes required to reach the desired state of the configuration. Essentially, it makes the changes to our 
infrastructure as specified in the execution plan generated by the terraform plan command.

1. Executes the Plan: It takes the proposed actions outlined in the execution plan and makes those changes to our infrastructure.
2. Creates, Modifies, or Destroys Resources: Based on the plan, it will create, update, or delete the necessary resources 
to match the desired state.
3. State Update: After making the changes, it updates the Terraform state file to reflect the current state of the infrastructure.

```hcl
TF_WORKSPACE=sandbox terraform apply -var-file=sandbox.tfvars
var.resource_group_name
  Resource group where to deploy.

  Enter a value: YOUR_RESOURCE_GROUP_HERE
```

#### Destroy
To destroy the infrastructure managed by our Terraform configuration. This command is used to delete all the resources that 
were created by terraform apply.

1. Reads the Current State: Terraform reads the current state of the infrastructure from the state file.
2. Creates a Plan to Destroy: It generates a plan that shows which resources will be destroyed.
3. Deletes Resources: Executes the plan and deletes the resources from our infrastructure.

```hcl
TF_WORKSPACE=sandbox terraform destroy -var-file=sandbox.tfvars
```

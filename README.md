# Terraform-AWS-SageMaker-Notebook-Infrastructure

Machine Learning Infrastructure with Amazon SageMaker and Terraform - DeepRacer Setup
--------------------------------------------------------------------------------------------------------------


### Infrastructure setup for the Amazon SageMaker Notebook instance with (Jupyter Notebook)
```
> mkdir -p terraform
```

```
> cd terraform
 ```
 
 ### IAM Role and Policy for the notebook instance:

 ```
# iam_sagemaker.tf

resource "aws_iam_role" "sm_notebook_instance_role" {
  name = "sm-notebook-instance-role"
   ...
  }
  
resource "aws_iam_role_policy_attachment" "sm_notebook_instance" {
  role       = "${aws_iam_role.sm_notebook_instance_role.name}"
  policy_arn = "${aws_iam_policy.sm_notebook_instance_policy.arn}"
}


resource "aws_iam_policy" "sm_notebook_instance_policy" {
  name        = "sm-notebook-instance-policy"
  description = "Policy for the Notebook Instance to manage training jobs, models and endpoints"
   ...
}

 ```
 


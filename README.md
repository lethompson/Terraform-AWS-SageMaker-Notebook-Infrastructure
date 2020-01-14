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
 
 ### S3 bucket for storing the Jupyter notebook:

 ```
# s3_lambda.tf

resource "aws_s3_bucket" "deep_racer_function_bucket" {
  bucket = "${var.function_bucket_name}-${var.aws_region}"
  acl    = "private"
  ...
  }


 ```
 
 ### S3 bucket for storing training data as well as generated model data:

 ```
# s3_sagemaker.tf

resource "aws_s3_bucket" "s3_bucket_1" {
  bucket        = "${var.s3_bucket_name_1}-${var.aws_region}"
  acl           = "private"
  ...
 }
 
resource "aws_s3_bucket_object" "s3_deep_racer_notebook" {
  bucket = "${aws_s3_bucket.deep_racer_function_bucket.id}"
  key    = "tf-deep-racer-using-machine-learning/${var.function_version}/notebooks/DeepRacerLogAnalysis.ipynb"
  source = "${path.module}/../source/notebooks/DeepRacerLogAnalysis.ipynb"
}
 ```
 
  ### Amazon SageMaker notebook instance:

 ```
# sagemaker.tf

resource "aws_sagemaker_notebook_instance" "basic" {
  name                  = "my-deepracer-model"
  role_arn              = "${aws_iam_role.sm_notebook_instance_role.arn}"
  instance_type         = "ml.t3.xlarge"
  ...
}
 ```
 
   ### Notebook instance init script:
   #### init script that downloads the notebook from the aws_s3_bucket.deep_racer_function_bucket

 ```
# sagemaker.tf

resource "aws_sagemaker_notebook_instance" "basic" {
  name                  = "my-deepracer-model"
  role_arn              = "${aws_iam_role.sm_notebook_instance_role.arn}"
  instance_type         = "ml.t3.xlarge"
  lifecycle_config_name = "${aws_sagemaker_notebook_instance_lifecycle_configuration.basic_lifecycle.name}"
  ...
}

resource "aws_sagemaker_notebook_instance_lifecycle_configuration" "basic_lifecycle" {
  name     = "BasicNotebookInstanceLifecycleConfig"

  on_start = "${base64encode(data.template_file.instance_init.rendered)}"
  ...
}

data "template_file" "instance_init" {
  template = "${file("${path.module}/template/sagemaker_instance_init.sh")}"
  ...
}

 ```

   ### sagemaker_instance_init.sh (script to copy Juypter notebook code from S3 bucket to Sagemaker instance)
   
   ```
   cd /home/ec2-user/SageMaker
   aws s3 cp s3://${function_bucket_name}-${aws_region}/tf-deep-racer-using-machine-learning/${function_version}/notebooks  /DeepRacerLogAnalysis.ipynb .
   ```
 

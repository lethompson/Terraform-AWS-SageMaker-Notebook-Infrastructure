cd /home/ec2-user/SageMaker
aws s3 cp s3://${function_bucket_name}-${aws_region}/tf-deep-racer-using-machine-learning/${function_version}/notebooks/DeepRacerLogAnalysis.ipynb .

output "beanstalk_endpoint" {
  value = aws_elastic_beanstalk_environment.vprofile-bean.endpoint_url
  description = "Elastic Beanstalk environment CNAME URL"
}
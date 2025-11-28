resource "aws_elastic_beanstalk_environment" "vprofile-bean" {
  name                = var.BEANSTACK_ENV_NAME
  application         = "vprofile-app"
  solution_stack_name = "64bit Amazon Linux 2023 v5.7.2 running Tomcat 10 Corretto 21"


  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "vprofile-beanstalk-EC2-Role"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "gp3"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = true
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = true
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", var.SUBNETS)
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.SUBNETS)
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.micro"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "vprofile-prod-key"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "environment"
    value     = "prod"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "sg-02bf05da937798a05" //EC2
  }

 // setting {
   // namespace = "aws:elbv2:loadbalancer"
    //name      = "SecurityGroups"
    //value     = "sg-0fe626266f9befe89" //ALB 
  //}

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "RDS_USERNAME"
    value     = "arn:aws:ssm:us-east-1:441160708640:parameter/RDS_USERNAME"
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "RDS_PASSWORD"
    value     = "arn:aws:ssm:us-east-1:441160708640:parameter/RDS_PASSWORD"
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "RABBITMQ_USERNAME"
    value     = "arn:aws:ssm:us-east-1:441160708640:parameter/RABBITMQ_USERNAME"
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environmentsecrets"
    name      = "RABBITMQ_PASSWORD"
    value     = "arn:aws:ssm:us-east-1:441160708640:parameter/RABBITMQ_PASSWORD"
    
  }

}
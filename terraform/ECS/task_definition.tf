resource "aws_ecs_task_definition" "vprofile-task_definition" {
  family                   = "${var.CLUSTER_NAME}-task"
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
 
  runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture        = "X86_64"
        }

  execution_role_arn = var.TASK_ECECUTION_ROLE_ARN
  

  container_definitions = jsonencode([
    {
      name  = var.CONTAINER_NAME
      image = var.CONTAINER_IMAGE

      secrets = [
        {
          name      = "RDS_USERNAME"
          valueFrom = "arn:aws:ssm:us-east-1:441160708640:parameter/RDS_USERNAME"
        },
        {
          name      = "RDS_PASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:441160708640:parameter/RDS_PASSWORD"
        },
        {
          name       = "RABBITMQ_USERNAME"
          valueFrom = "arn:aws:ssm:us-east-1:441160708640:parameter/RABBITMQ_USERNAME"
        },
        {
          name      = "RABBITMQ_PASSWORD"
          valueFrom = "arn:aws:ssm:us-east-1:441160708640:parameter/RABBITMQ_PASSWORD"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.LOG_GROUP_NAME
          awslogs-region        = var.AWS_REGION
          awslogs-stream-prefix = "ecs"
        }
      }

      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
    }
  ])
}
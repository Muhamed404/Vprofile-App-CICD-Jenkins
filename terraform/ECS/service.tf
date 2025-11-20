resource "aws_ecs_service" "backend" {
  name            = "${var.CLUSTER_NAME}-service"
  cluster         = aws_ecs_cluster.vprofile-cluster.id
  task_definition = aws_ecs_task_definition.vprofile-task_definition.arn
  launch_type     = "FARGATE"

  desired_count = 1

  network_configuration {
    subnets         = var.SUBNETS
    security_groups = var.ECS_SG
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.vprofile-task_definition,
  ]
}
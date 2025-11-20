resource "aws_ecs_cluster" "vprofile-cluster" {
  name = var.CLUSTER_NAME
}
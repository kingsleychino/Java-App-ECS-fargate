# ECS Service
resource "aws_ecs_service" "java-app" {
  name            = "java-app-container"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.java-app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_sg.id]
  }
}
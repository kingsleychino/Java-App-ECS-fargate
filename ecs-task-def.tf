# Task Definition
resource "aws_ecs_task_definition" "java-app" {
  family                   = "java-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([{
    name      = "java-app-container"
    image     = "503499294473.dkr.ecr.us-east-1.amazonaws.com/simple-java-app:v1.1"
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
      protocol      = "tcp"
    }]
  }])
}
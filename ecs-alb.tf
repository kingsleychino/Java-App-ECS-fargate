# Application Load Balancer
resource "aws_lb" "app_lb" {
  name               = "java-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.public-subnet-a.id, aws_subnet.public-subnet-b.id]

  enable_deletion_protection = false

  tags = {
    Name = "Java-App-ALB"
  }
}

# Target group for ECS service
resource "aws_lb_target_group" "app_tg" {
  name        = "java-app-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.dev-vpc.id
  target_type = "ip" # required for Fargate

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "Java-App-TG"
  }
}

# Listener for HTTP (port 80)
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

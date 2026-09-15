resource "aws_lb" "alb" {
  name               = "${var.alb_name}-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    Name = "Main-Alb-${var.environment}"
    Environment = var.environment
  }
}
resource "aws_lb_target_group" "tg" {
  name        = "${var.alb_name}-${terraform.workspace}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
    interval            = 30          
    timeout             = 5        
    healthy_threshold   = 2          
    unhealthy_threshold = 5           
    matcher             = "200"
  }
}

resource "aws_lb_target_group_attachment" "instances" {
  for_each = var.instance_ids

  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
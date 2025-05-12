resource "aws_db_subnet_group" "main" {
  name        = var.project_name
  subnet_ids  = var.private_subnets
  description = "Grupo de subredes para RDS"

  tags = {
    Name = "${var.project_name}-subnet-group-${var.environment}"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg-${var.environment}"
  description = "Security group para RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow PostgreSQL access from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg-${var.environment}"
  }
}

resource "aws_db_instance" "postgresql" {
  identifier = "${var.project_name}-${var.environment}"
  engine     = "postgres"
  engine_version = "14.18"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp2"
  storage_encrypted = true

  db_name  = replace("${var.project_name}_${var.environment}", "-", "_")
  username = var.db_username
  password = var.db_password
  port     = 5432

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  publicly_accessible    = true

  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "Mon:04:00-Mon:05:00"

  skip_final_snapshot = true

  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]

  performance_insights_enabled = true
  performance_insights_retention_period = 7

  tags = {
    Name = "${var.project_name}-rds-${var.environment}"
  }
}

resource "aws_secretsmanager_secret" "rds_credentials" {
  name = "${var.project_name}-rds-credentials-${var.environment}-${random_string.suffix.result}"
  
  tags = {
    Name        = "${var.project_name}-rds-credentials-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id = aws_secretsmanager_secret.rds_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    host     = aws_db_instance.postgresql.endpoint
    port     = 5432
    dbname   = aws_db_instance.postgresql.db_name
    url      = "r2dbc:postgresql://${aws_db_instance.postgresql.endpoint}/${aws_db_instance.postgresql.db_name}"
  })
}

# ECS Task Definition para Flyway
resource "aws_ecs_task_definition" "flyway" {
  family                   = "${var.project_name}-flyway-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn           = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name  = "flyway"
      image = "flyway/flyway:9.21"
      
      command = [
        "migrate",
        "-url=jdbc:postgresql://${aws_db_instance.postgresql.endpoint}/${aws_db_instance.postgresql.db_name}",
        "-user=${var.db_username}",
        "-password=${var.db_password}",
        "-locations=filesystem:/flyway/sql"
      ]

      mountPoints = [
        {
          sourceVolume  = "migrations"
          containerPath = "/flyway/sql"
          readOnly     = true
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-flyway-${var.environment}"
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "flyway"
        }
      }
    }
  ])

  volume {
    name = "migrations"
    efs_volume_configuration {
      file_system_id = aws_efs_file_system.migrations.id
      root_directory = "/"
    }
  }

  tags = {
    Name        = "${var.project_name}-flyway-task-${var.environment}"
    Environment = var.environment
  }
}

# EFS para almacenar los scripts de migración
resource "aws_efs_file_system" "migrations" {
  creation_token = "${var.project_name}-migrations-${var.environment}"
  encrypted      = true

  tags = {
    Name        = "${var.project_name}-migrations-${var.environment}"
    Environment = var.environment
  }
}

resource "aws_efs_mount_target" "migrations" {
  count           = length(var.private_subnets)
  file_system_id  = aws_efs_file_system.migrations.id
  subnet_id       = var.private_subnets[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "${var.project_name}-efs-sg-${var.environment}"
  description = "Security group para EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-efs-sg-${var.environment}"
    Environment = var.environment
  }
}

data "aws_region" "current" {} 
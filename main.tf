## EC2 Server ##
resource "aws_instance" "main" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  iam_instance_profile   = aws_iam_instance_profile.main.name
  user_data = templatefile("${path.module}/minecraft-userdata.sh.tftpl", {
    app_name                            = var.app_name
    minecraft_server_port               = var.minecraft_server_port
    minecraft_server_type               = var.minecraft_server_type
    minecraft_memory_G                  = var.minecraft_memory_G
    minecraft_max_players               = var.minecraft_max_players
    minecraft_motd                      = var.minecraft_motd
    minecraft_timezone                  = var.minecraft_timezone
    minecraft_difficulty_level          = var.minecraft_difficulty_level
    minecraft_gamemode                  = var.minecraft_gamemode
    minecraft_world_name                = var.minecraft_world_name
    minecraft_world_seed                = var.minecraft_world_seed
    minecraft_ops_list                  = var.minecraft_ops_list
    minecraft_rcon_cmds_last_disconnect = var.minecraft_rcon_cmds_last_disconnect
    ftb_modpack_id                      = var.ftb_modpack_id
    ftb_modpack_version_id              = var.ftb_modpack_version_id
  })

  tags = {
    Name = var.app_name
  }
}

## Key Pair ##
resource "aws_key_pair" "main" {
  key_name   = "${var.app_name}-key-pair"
  public_key = file(pathexpand(var.public_key_pair_path))
}

## Security Group ##
resource "aws_security_group" "main" {
  name        = "${var.app_name}-sg"
  description = "Minecraft server module security group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "ingress" {
  for_each          = var.security_group_ingress_rules
  security_group_id = aws_security_group.main.id
  type              = "ingress"
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}


resource "aws_security_group_rule" "egress" {
  for_each          = var.security_group_egress_rules
  security_group_id = aws_security_group.main.id
  type              = "egress"
  description       = each.value.description
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
}

## IAM Config ## 
resource "aws_iam_instance_profile" "main" {
  name = "${var.app_name}-iam-instance-profile"
  role = aws_iam_role.main.name
}

resource "aws_iam_role" "main" {
  name = "${var.app_name}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "minecraft_ssm_policy" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

## Outputs ##
output "instance_id" {
  value       = aws_instance.main.id
  description = "The ID of the EC2 instance"
}

output "instance_public_ip" {
  value       = aws_instance.main.public_ip
  description = "Public IP address of the EC2 instance"
}
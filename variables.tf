variable "app_name" {
  type      = string
  sensitive = false
}

variable "additional_user_data" {
  type      = string
  sensitive = false
  default = ""
}

variable "vpc_id" {
  type      = string
  sensitive = true
}

variable "ami" {
  type      = string
  sensitive = false
  default   = "ami-06b21ccaeff8cd686"
}

variable "instance_type" {
  type      = string
  sensitive = false
}

variable "minecraft_server_port" {
  type      = number
  sensitive = false
  default   = 25565
}

variable "minecraft_server_type" {
  type      = string
  sensitive = false
  default   = "Vanilla"
}

variable "ftb_modpack_id" {
  type      = number
  sensitive = false
  default   = 0
}

variable "ftb_modpack_version_id" {
  type      = number
  sensitive = false
  default   = 0
}

variable "minecraft_memory_G" {
  type      = number
  sensitive = false
}

variable "minecraft_timezone" {
  type      = string
  sensitive = false
  default   = "America/New_York"
}

variable "minecraft_max_players" {
  type      = number
  sensitive = false
  default   = 20
}

variable "minecraft_world_name" {
  type      = string
  sensitive = false
  default   = "world"
}

variable "minecraft_world_seed" {
  type      = string
  sensitive = false
  default   = ""
}

variable "minecraft_gamemode" {
  type      = number
  sensitive = false
  default   = 1
}

variable "minecraft_motd" {
  type      = string
  sensitive = false
  default   = "Minecraft Server"
}

variable "minecraft_difficulty_level" {
  type      = number
  sensitive = false
  default   = 1
}

variable "minecraft_ops_list" {
  type      = string
  sensitive = false
  default   = ""
}

variable "minecraft_rcon_cmds_last_disconnect" {
  type      = string
  sensitive = false
  default   = ""
}

variable "public_key_pair_path" {
  type      = string
  sensitive = false
  default   = "~/.ssh/id_ed25519.pub"
}

variable "security_group_ingress_rules" {
  description = "List of ingress rules for the security group"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = set(string)
  }))
}

variable "security_group_egress_rules" {
  description = "List of egress rules for the security group"
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = set(string)
  }))

  default = {
    "allow-all-egress" = {
      description = "Allow all outbound traffic"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

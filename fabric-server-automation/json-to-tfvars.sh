#!/bin/bash

# Converts form JSON to Terraform tfvars format
# Usage: ./json-to-tfvars.sh <form-config.json> <vpc-id>

set -e

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: ./json-to-tfvars.sh <form-config.json> <vpc-id>"
    exit 1
fi

CONFIG_FILE="$1"
VPC_ID="$2"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Config file not found: $CONFIG_FILE"
    exit 1
fi

# Parse JSON config
SERVER_NAME=$(jq -r '.server_name' "$CONFIG_FILE")
SERVER_VERSION=$(jq -r '.server_version' "$CONFIG_FILE")
MEMORY_MAX=$(jq -r '.memory_max' "$CONFIG_FILE")
SERVER_PORT=$(jq -r '.server_port' "$CONFIG_FILE")
GAME_MODE=$(jq -r '.game_mode' "$CONFIG_FILE")
DIFFICULTY=$(jq -r '.difficulty' "$CONFIG_FILE")
MAX_PLAYERS=$(jq -r '.max_players' "$CONFIG_FILE")
WORLD_SEED=$(jq -r '.world_seed' "$CONFIG_FILE")
LEVEL_NAME=$(jq -r '.level_name' "$CONFIG_FILE")
MOTD=$(jq -r '.motd' "$CONFIG_FILE")
OP_PLAYERS=$(jq -r '.op_players' "$CONFIG_FILE")

# Set defaults
[ "$SERVER_PORT" = "null" ] || [ -z "$SERVER_PORT" ] && SERVER_PORT="25565"
[ "$WORLD_SEED" = "null" ] && WORLD_SEED=""

# Convert game_mode to number (Docker container expects numbers)
case "$GAME_MODE" in
  "survival") GAMEMODE_NUM=0 ;;
  "creative") GAMEMODE_NUM=1 ;;
  "adventure") GAMEMODE_NUM=2 ;;
  "spectator") GAMEMODE_NUM=3 ;;
  *) GAMEMODE_NUM=0 ;;
esac

# Convert difficulty to number
case "$DIFFICULTY" in
  "peaceful") DIFFICULTY_NUM=0 ;;
  "easy") DIFFICULTY_NUM=1 ;;
  "normal") DIFFICULTY_NUM=2 ;;
  "hard") DIFFICULTY_NUM=3 ;;
  *) DIFFICULTY_NUM=2 ;;
esac

# Determine instance type based on memory
if [ "$MEMORY_MAX" -ge 16 ]; then
  INSTANCE_TYPE="t3.2xlarge"
elif [ "$MEMORY_MAX" -ge 8 ]; then
  INSTANCE_TYPE="t3.xlarge"
elif [ "$MEMORY_MAX" -ge 4 ]; then
  INSTANCE_TYPE="t3.large"
else
  INSTANCE_TYPE="t3.medium"
fi

# Generate terraform.tfvars.json
cat > terraform.tfvars.json <<EOF
{
  "app_name": "$SERVER_NAME",
  "instance_type": "$INSTANCE_TYPE",
  "vpc_id": "$VPC_ID",
  "minecraft_server_port": $SERVER_PORT,
  "minecraft_server_type": "FABRIC",
  "minecraft_memory_G": $MEMORY_MAX,
  "minecraft_timezone": "America/New_York",
  "minecraft_max_players": $MAX_PLAYERS,
  "minecraft_world_name": "$LEVEL_NAME",
  "minecraft_world_seed": "$WORLD_SEED",
  "minecraft_gamemode": $GAMEMODE_NUM,
  "minecraft_motd": "$MOTD",
  "minecraft_difficulty_level": $DIFFICULTY_NUM,
  "minecraft_ops_list": "$OP_PLAYERS",
  "minecraft_rcon_cmds_last_disconnect": "",
  "ftb_modpack_id": 0,
  "ftb_modpack_version_id": 0,
  "security_group_ingress_rules": {
    "minecraft": {
      "description": "Minecraft server port",
      "from_port": $SERVER_PORT,
      "to_port": $SERVER_PORT,
      "protocol": "tcp",
      "cidr_blocks": ["0.0.0.0/0"]
    },
    "ssh": {
      "description": "SSH access",
      "from_port": 22,
      "to_port": 22,
      "protocol": "tcp",
      "cidr_blocks": ["0.0.0.0/0"]
    }
  }
}
EOF

echo "✓ Generated terraform.tfvars.json"
echo "Server: $SERVER_NAME"
echo "Instance Type: $INSTANCE_TYPE"
echo "Memory: ${MEMORY_MAX}G"
echo "Game Mode: $GAME_MODE ($GAMEMODE_NUM)"
echo "Difficulty: $DIFFICULTY ($DIFFICULTY_NUM)"
echo ""
echo "Next steps:"
echo "1. Copy Terraform files to this directory or copy terraform.tfvars.json to your Terraform directory"
echo "2. Run: terraform init"
echo "3. Run: terraform plan"
echo "4. Run: terraform apply"

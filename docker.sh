#!/bin/bash

set -euo pipefail

# Logger function
source "./logger.sh"

# Function to display help
show_help() {
  echo "Usage: ./docker.sh [dev|stage|prod]"
  echo ""
  echo "Environments:"
  echo "  dev   - Development (uses docker-compose.override.yml with bundled PostgreSQL)"
  echo "  stage - Staging (uses docker-compose.yml with bundled PostgreSQL)"
  echo "  prod  - Production (uses docker-compose.prod.yml with external managed DB)"
  echo ""
  echo "For production setup with managed database, see DEPLOYMENT.md"
}

COMPOSE_FILES=()

## Function for cleanup and proper shutdown
cleanup() {
  log "WARNING" "Interrupt signal received. Performing cleanup..."

  case "$ENV" in
  "dev")
    docker-compose down
    ;;
  *)
    if [ ${#COMPOSE_FILES[@]} -gt 0 ]; then
      docker-compose "${COMPOSE_FILES[@]}" down || true
    fi
    ;;
  esac

  exit 0
}

# Set interrupt handler
trap cleanup SIGINT SIGTERM

# Initialize variables with default values
ENV=""
NODE_ENV=""
CONFIG_NAME=""

# Function to set environment variables
set_environment() {
  case "$1" in
  "dev")
    ENV="dev"
    NODE_ENV="development"
    CONFIG_NAME="dev"
    ;;
  "stage")
    ENV="stage"
    NODE_ENV="staging"
    CONFIG_NAME="stage_docker"
    ;;
  "prod")
    ENV="prod"
    NODE_ENV="production"
    CONFIG_NAME="prod_docker"
    ;;
  *)
    log "ERROR" "Invalid environment. Use ./deploy.sh -h for help."
    exit 1
    ;;
  esac
}

# Determine environment based on script argument
if [ "${1-}" = "-h" ] || [ "${1-}" = "--help" ]; then
  show_help
  exit 0
else
  set_environment "${1-}"
fi

export DOCKER_USERNAME="$(doppler secrets get DOCKER_USERNAME --plain --config "$CONFIG_NAME")"
export PROJECT_NAME="$(doppler secrets get DOPPLER_PROJECT --plain --config "$CONFIG_NAME")"
export PROJECT_VERSION="$ENV"

# Export vars
export NODE_ENV

# Set Doppler Config
doppler configure set config "$CONFIG_NAME"

# Load Doppler Secrets
export eval $(doppler secrets download --no-file --format docker)

# Run the application based on the environment
if [ "$ENV" = "dev" ]; then
  log "INFO" "Running Docker Compose for DEV environment..."
  docker-compose up
else
  # Determine Docker Compose file
  if [ "$NODE_ENV" = "production" ] && [ -f docker-compose.prod.yml ]; then
    # Production: use external managed database
    COMPOSE_FILES=("-f" "docker-compose.prod.yml")
  else
    # Staging: use bundled PostgreSQL
    COMPOSE_FILES=("-f" "docker-compose.yml")
  fi
  DOCKERFILE="Dockerfile"

  if [ ! -f "$DOCKERFILE" ]; then
    log "ERROR" "File $DOCKERFILE not found."
    exit 1
  fi

  log "INFO" "Building Docker image for $ENV..."
  docker build \
    --memory=6g \
    --build-arg NODE_ENV="$NODE_ENV" \
    --build-arg STRAPI_URL="${STRAPI_URL}" \
    -t "$DOCKER_USERNAME/$PROJECT_NAME:$PROJECT_VERSION" \
    -f "$DOCKERFILE" .

  log "INFO" "Running Docker Compose for environment $ENV..."

  docker-compose "${COMPOSE_FILES[@]}" up
fi

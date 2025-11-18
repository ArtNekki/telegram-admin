# Makefile for various SSH and Docker operations

# Variables
IP ?= 127.0.0.1
SSH_DIR := $(HOME)/.ssh
KNOWN_HOSTS := $(SSH_DIR)/known_hosts

# Phony targets
.PHONY: all copy-id-pub copy-id rm-images known-hosts help local dev docker-dev

# Default target
all: help

# Copy public SSH key to clipboard
copy-id-pub:
	@pbcopy < $(SSH_DIR)/id_rsa.pub
	@echo "Public key copied to clipboard"

# Copy private SSH key to clipboard
copy-id:
	@pbcopy < $(SSH_DIR)/id_rsa
	@echo "Private key copied to clipboard"

# Remove all unused Docker images
rm-images:
	@docker image prune -af
	@echo "Unused Docker images removed"

# Generate known_hosts file
known-hosts:
	@echo "Generating known_hosts for IP: $(IP)"
	@ssh-keyscan -H $(IP) >> $(KNOWN_HOSTS)
	@echo "$(KNOWN_HOSTS) file updated"

# Help target
help:
	@echo "Available targets:"
	@echo "  copy-id-pub  - Copy public SSH key to clipboard"
	@echo "  copy-id      - Copy private SSH key to clipboard"
	@echo "  rm-images    - Remove all unused Docker images"
	@echo "  known-hosts  - Generate known_hosts file (use IP=x.x.x.x to specify IP)"
	@echo "  help         - Show this help message"

dev:
	@doppler run --config local -- bash -c 'npm run dev'
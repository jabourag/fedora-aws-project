# Hardened Fedora Golden Image (AWS)


## Project Purpose
This repository serves as the source of truth for Fedora Lane's secure cloud base image. It addresses the challenge of providing a standardized, CIS-hardened OS environment while maintaining strict security controls (SELinux in `Enforcing` mode, restricted SSH access) and providing an auditable, GUI-based management interface for administrators.

## Repository Contents
* `scripts/setup_environment.sh`: Automated deployment script to install Cockpit, Session Recording, Podman, and configure SSH boundaries.
* `.pre-commit-config.yaml`: Code hygiene hooks enforcing YAML standards and preventing credential leaks.

## Setup and Deployment Instructions

### 1. Pre-requisites
* An active AWS EC2 instance running a base Fedora/RHEL image.
* Local SSH key access to the instance.

### 2. Deploying the Environment
Upload and execute the setup script on the target server:
`scp -i /path/to/key.pem scripts/setup_environment.sh ec2-user@<AWS_INSTANCE_IP>:/home/ec2-user/`
`ssh -i /path/to/key.pem ec2-user@<AWS_INSTANCE_IP>`
`sudo ./setup_environment.sh`

### 3. Running the Solution
To securely access the hardened Web Console without exposing port 9090 to the internet, use an SSH tunnel over the restricted management port (2222):
`ssh -i /path/to/key.pem -p 2222 -L 9090:localhost:9090 ec2-user@<AWS_INSTANCE_IP>`
Once connected, open a local web browser and navigate to `https://localhost:9090`.

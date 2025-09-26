#!/bin/bash

# Switch to root
sudo -i

# Update system
yum update -y

# Install Git
yum install -y git

# Add Jenkins repo
wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Amazon Corretto 17 (works well with Jenkins)
amazon-linux-extras enable corretto17
yum install -y java-17-amazon-corretto

# Verify Java
java -version

# Install Jenkins
yum install -y jenkins
    
# Enable and start Jenkins
systemctl enable jenkins
systemctl start jenkins

# Install Docker
yum install -y docker
systemctl enable docker
systemctl start docker

# Add users to Docker group
usermod -aG docker ec2-user
usermod -aG docker jenkins

# Restart Jenkins so it picks up Java + Docker group changes
systemctl enable jenkins
systemctl start jenkins

# Verify Docker
docker --version

# Install AWS CLI v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Authenticate with ECR (requires IAM role with ECR permissions)
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin 503499294473.dkr.ecr.us-east-1.amazonaws.com
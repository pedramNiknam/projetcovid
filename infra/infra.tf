provider "aws" {
    region = var.region_id
}

resource "aws_instance" "covidInfraEC2" { 
    ami = var.ami_id
    instance_type = var.type_EC2
    security_groups = [aws_security_group.covid_sg.name]
    key_name = aws_key_pair.olvCkeypair.key_name
    tags = {
        "Name" = "infraCovidProjet" 
    }

    user_data = <<-EOF
        #!/bin/bash
        apt update
        apt-get update

        #install docker
        apt install docker.io -y

        #install docker compose
        curl -L "https://github.com/docker/compose/releases/download/1.28.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        
        #copier projet git hadoop et lancer docker-compose
        cd /home/ubuntu
        git clone https://github.com/big-data-europe/docker-hadoop-spark-workbench
        cd docker-hadoop-spark-workbench/
        docker-compose -f docker-compose-hive.yml up -d

      EOF
}

//associer une keypair pour ssh. 
resource "aws_key_pair" "olvCkeypair" {
  key_name_prefix   = "olv-keypair-"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCw0AExreQ638y6hFoNVod42/wI9VCGRJX6n2RHcXVKxmkhv6+nWg6xTXo1tM7K3igvGyE8xwuuLyBtE/KH1EY8/mVDXiMpr/5OqER8ITVFFbvnV9zCb8XS7+T5XnQcZZx50Wk8ni0pVWPIcPv9O/LF6Y+m+VJJRAWPrF3lxywgW9O7NbaUk0MRwdF8EK7hi6kfT7GvfP5v6l8iKRsxkg18WRKpcgoowFUT2dgkjkhMKJocRMXOERxrZ3oOKC66UN1rK+P74MHlMqerddzqyIeO0Dz8rxFleCat7exSa87ShXKF+6m2zcVGfuUeEhmGONIlI2bnCbGd4qIPyh7DX63/B1C/SgjylbaM6e8DCEh3dRSJRmRI7WibuvPZuQ0oY9NR48aWG6hVVdt+CYQwERW3ToJ+PusGWy/QagSj9/3+mKwub7ZaVqcbgwu5j/JcXDH8we3o71A9/qktnFuD2hJP//Ypjqkbk7yzQDTCd2C2ZBrSeVm3yfHXPtbf/GnLuuc= fitec@FITEC"
}

//security group pour connexion 
resource "aws_security_group" "covid_sg" {
  name        = "covidprojet_sg"
  vpc_id      = data.aws_vpc.vpc_id.id

  ingress {
    description = "http from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    description = "http over ssl from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "impala from anywhere"
    from_port   = 21050
    to_port     = 21050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "hive from anywhere"
    from_port   = 10000
    to_port     = 10000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "webHDFS from anywhere"
    from_port   = 50070
    to_port     = 50070
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

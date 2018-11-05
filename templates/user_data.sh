#!/bin/bash

sudo mkdir /home/deploy/.ssh
sudo mkdir -p /home/deploy/apps/DevOps-RoR/current
sudo cp /home/ubuntu/.ssh/authorized_keys /home/deploy/.ssh/authorized_keys
sudo chown deploy:deploy /home/deploy/.ssh/authorized_keys
sudo chown deploy:deploy /home/deploy/apps/DevOps-RoR/current
sudo chmod 755 /home/deploy/apps/DevOps-RoR/current
sudo service nginx restart
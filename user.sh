script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[33m>>>>>>>>> configuring nodejs  repos <<<<<<<<\e[0m"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -

echo -e "\e[33m>>>>>>>>> Install Nodejs  repos <<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[33m>>>>>>>>> Add  Application User  <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[33m>>>>>>>>> Created Application  Directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[33m>>>>>>>>> Download  App  Content <<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[33m>>>>>>>>> Unzip App  Content <<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[33m>>>>>>>>> Install   NodeJS  Dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[33m>>> Copy Catalogue SystemD file <<<<<<<<\e[0m"
cp /root/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[33m>>> Start  User Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user ; tail /var/log/messages

echo -e "\e[33m>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m>>> Install  MongoDB Client  <<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[33m>>> Load Schema  <<<<<<<<\e[0m"
mongo --host mongodb-dev.rajasekhar72.store </app/schema/user.js

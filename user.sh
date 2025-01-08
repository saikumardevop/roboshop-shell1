echo -e "\e[31m>>>>>>>>> configuring nodejs  repos <<<<<<<<\e[0m"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -

echo -e "\e[31m>>>>>>>>> Install Nodejs  repos <<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[31m>>>>>>>>> Add  Application User  <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>> Created Application  Directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>> Download  App  Content <<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[31m>>>>>>>>> Unzip App  Content <<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[31m>>>>>>>>> Install   NodeJS  Dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[31m>>> Copy Catalogue SystemD file <<<<<<<<\e[0m"
cp /root/roboshop-shell/user.service /etc/systemd/system/user.service

echo -e "\e[31m>>> Start  User Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user ; tail /var/log/messages

echo -e "\e[31m>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>> Install  MongoDB Client  <<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[31m>>> Load Schema  <<<<<<<<\e[0m"
mongo --host mongodb-dev.rajasekhar72.store </app/schema/catalogue.js

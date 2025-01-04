echo -e "\e[31m>>>>>>>>> configuring nodejs  repos <<<<<<<<\e[0m"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -

echo -e "\e[31m>>>>>>>>> Install Nodejs  repos <<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[31m>>>>>>>>> Add  Application User  <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>> Createb Application  Directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>> Download  App  Content <<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m>>>>>>>>> Unzip App  Content <<<<<<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[31m>>>>>>>>> Install   NodeJS  Dependencies <<<<<<<<\e[0m"
npm install

echo -e "\e[31m>>> Copy Catalogue SystemD file <<<<<<<<\e[0m"
cp /root/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m>>> Start  Catalogue Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue

echo -e "\e[31m>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>> Install  MongoDB Client  <<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[31m>>> Load Schema  <<<<<<<<\e[0m"
mongo --host mongodb.rajasekhar72.store </app/schema/catalogue.js
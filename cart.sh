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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[33m>>>>>>>>> Unzip App  Content <<<<<<<<\e[0m"
unzip /tmp/cart.zip

echo -e "\e[33m>>>>>>>>> Install   NodeJS  Dependencies <<<<<<<<\e[0m"
npm install
echo -e "\e[33m>>> Copy Catalogue SystemD file <<<<<<<<\e[0m"
cp /root/roboshop-shell/cart.service /etc/systemd/system/cart.service

echo -e "\e[33m>>> Start  User Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl restart cart ; tail /var/log/messages

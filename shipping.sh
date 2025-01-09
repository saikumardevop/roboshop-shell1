echo -e "\e[31m>>>>>>>>> Maven Installation <<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[31m>>>>>>>>> Created  Application User  <<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[31m>>>>>>>>> Created Application  Directory<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>>>>>>> Download  App  Content <<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[31m>>>>>>>>> Unzip App  Content <<<<<<<<\e[0m"
unzip /tmp/shipping.zip

echo -e "\e[31m>>>>>>>>> Download   Maven  Dependencies <<<<<<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m>>> INSTALL MYSQL file <<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[31m>>> Load Schema <<<<<<<<\e[0m"
mysql -h mysql.rajasekhar72.store  -uroot -pRoboShop@1 < /app/schema/shipping.sql

echo -e "\e[31m>>> Setup Systemd Service <<<<<<<<\e[0m"
cp /root/roboshop-shell/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m>>> Start  shipping Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

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
mysql -h mysql-dev.rajasekhar72.store  -uroot -p${mysql_root_password} < /app/schema/shipping.sql

echo -e "\e[31m>>> Setup Systemd Service <<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m>>> Start  shipping Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
echo -e "\e[33m>>>>>>>>>  Disable Mysql 8 version  <<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[33m>>>>>>>>>  Copy Mysql Repo File  <<<<<<<<\e[0m"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[33m>>>>>>>>> Installed Mysql <<<<<<<<\e[0m"
dnf install mysql-community-server -y

echo -e "\e[33m>>> Start MYSQL <<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[33m>>> Reset MYSQL  Password <<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1


script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
func_nodejs

echo -e "\e[33m>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp /root/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m>>> Install  MongoDB Client  <<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[33m>>> Load Schema  <<<<<<<<\e[0m"
mongo --host mongodb-dev.rajasekhar72.store </app/schema/user.js

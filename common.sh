app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs(){

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
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

echo -e "\e[33m>>>>>>>>> Unzip App  Content <<<<<<<<\e[0m"
unzip /tmp/${component}.zip

echo -e "\e[33m>>>>>>>>> Install   NodeJS  Dependencies <<<<<<<<\e[0m"
npm install

echo -e "\e[33m>>> Application Directory <<<<<<<<\e[0m"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

echo -e "\e[33m>>> Start  ${component} Service <<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component} ; tail /var/log/messages

}
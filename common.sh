app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

print_head(){
  echo -e "\e[36m >>>>>>>> $* <<<<<<<<<<<<\e[0m"
}

schema_setup(){
echo -e "\e[33m>>> Copy MongoDB repo <<<<<<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[33m>>> Install  MongoDB Client  <<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[33m>>> Load Schema  <<<<<<<<\e[0m"
mongo --host mongodb-dev.rajasekhar72.store </app/schema/${component}
}

func_nodejs(){

print_head  "configuring nodejs  repos"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | sudo bash -

print_head  "Install Nodejs  repos"
dnf install nodejs -y

print_head  "Add  Application User"
useradd roboshop

print_head  "Created Application  Directory"
rm -rf /app
mkdir /app

print_head  "Download  App  Content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head  "Unzip App  Content"
unzip /tmp/${component}.zip

print_head  "Install   NodeJS  Dependencies"
npm install

print_head "Application Directory"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

print_head "Start"
systemctl daemon-reload
systemctl enable ${component}
systemctl restart ${component} ; tail /var/log/messages

schema_setup

}
script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head "Download Maven Dependencies"
mvn clean package &>>$logfile
func_stat_check $?

func_print_head
yum install nginx -y &>>$log_file
func_stat_check $?

func_print_head
cp roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$log_file
func_stat_check $?

func_print_head
rm -rf /usr/share/nginx/html/* &>>$log_file
func_stat_check $?

func_print_head
curl -o/tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file
func_stat_check $?

func_print_head
cd /usr/share/nginx/html &>>$log_file
unzip /tmp/frontend.zip &>>$log_file
func_stat_check $?

func_print_head
sistemctl enable nginx &>>$log_file
systemctl restart nginx &>>$log_file
func_stat_check $?

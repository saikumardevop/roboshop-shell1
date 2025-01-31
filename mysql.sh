script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "mysql_root_password" ]; then
echo Input Roboshop Appuser password Missing
exit
fi

func_print_head "Disable Mysql 8 version"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "  Copy Mysql Repo File"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head " Installed Mysql"
dnf install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "Start MYSQL"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file
func_stat_check $?

func_print_head "Reset MYSQL  Password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?


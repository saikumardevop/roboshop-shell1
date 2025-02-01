script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
log_file=/tmp/roboshop.log
# rm -f $log_file

func_print_head(){
  echo -e "\e[36m >>>>>>>> $* <<<<"
  echo -e "\e[36m >>>>>>>> $* <<<<" &>>$log_file
}
func_stat_check (){
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[33mFALIURE\e[0m"
    echo "Refer the log file /tmp/roboshop.log for more information"
    exit 1
  fi
}

func_print_head "Disable MySQL 8 Version"
dnf module disable mysql -y &>>$log_file
func_stat_check $?

func_print_head "Copy MySQL Repo File"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file
func_stat_check $?

func_print_head "Install MySQL"
yum install mysql-community-server -y &>>$log_file
func_stat_check $?

func_print_head "Start MySQL"
systemctl enable mysqld &>>$log_file
systemctl restart mysqld &>>$log_file
func_stat_check $?

func_print_head "Reset MySQL Password"
mysql_secure_installation--set-root-pass $mysql_root_password &>>$log_file
func_stat_check $?
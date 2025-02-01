script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input MySQL Root Password Missing
  exit
fi

func_print_head "Disable MySQL 8 Version"
dnf module disable mysql -y
func_stat_check $?

func_print_head "Copy MySQL Repo File"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_stat_check $?

func_print_head "Install MySQL"
yum install mysql-community-server -y
func_stat_check $?

func_print_head "Start MySQL"
systemctl enable mysqld
systemctl restart mysqld
func_stat_check $?

func_print_head "Reset MySQL Password"
mysql_secure_installation--set-root-pass $mysql_root_password
func_stat_check $?
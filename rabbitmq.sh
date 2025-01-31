script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
 echo Input Roboshop Appuser Password Missing
 exit
fi

func_print_head "Setup ErLang Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
func_stat_check $?

func_print_head "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
func_stat_check $?

func_print_head "Install ErLang & RabbitMQ"
yum install erlang rabbitmq-server -y
func_stat_check $?

func_print_head "Start RabbitMQ Service"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server
func_stat_check $?

func_print_head "Add Application User in RabbtiMQ"
rabbitmqctl add_user roboshop ${frabbitmq appuser password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*""*"
func_stat_check $?
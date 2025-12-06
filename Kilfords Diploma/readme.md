/home/kilfords/.ssh
закинуть на bastion для доступа до остальных ВМ

подключение по ssh через ВМ bastion
ssh kilfords@web-1.ru-central1.internal
ssh kilfords@web-2.ru-central1.internal
ssh kilfords@kibana.ru-central1.internal
ssh kilfords@zabbix.ru-central1.internal
ssh kilfords@elasticsearch.ru-central1.internal

zabbix
user: Admin
pass: zabbix

dashboard: diploma

systemctl status nginx
systemctl status elasticsearch
systemctl status kibana
systemctl status zabbix-server

# сброс dns
resolvectl flush-caches

# проверка filebeat на web-1 | web-2
systemctl status filebeat

# проверка вывода es + filebeat на web-1 | web-2
curl -s http://elasticsearch.ru-central1.internal:9200
sudo filebeat test output


# запуск плэйбука ansible из под ВМ - bastion 
cd ~/ansible
ansible-playbook -i inventory/hosts.yml site.yml --ask-vault-pass
пароль на VAULT: esperanza

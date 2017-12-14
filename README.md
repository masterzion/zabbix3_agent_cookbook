This cookbook will install and start zabbix3 agent


Please check the file /etc/zabbix/zabbix_agentd.conf 

platforms:
  - ubuntu-16.04
  - centos-7
  - debian-8
 
:todo
  - ubuntu-14.04
  - centos-6
  

destroy
===
zabbix3_agent 'zabbix3_agent create' do
  action :destroy
end
===


Create
===
zabbix3_agent 'zabbix3_agent create' do
  server_name 'localhost'
  action :create
end
===

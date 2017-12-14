# # encoding: utf-8

# Inspec test for recipe zabbix3_agent_cookbook::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/


describe port(10050)  do
  it { should be_listening }
end


describe file('/var/log/zabbix_agentd.log')  do
  it { should exist }
end


describe file('/etc/zabbix/zabbix_agentd.conf')  do
  it { should exist }
end


describe user('zabbix')  do
  it { should exist }
end


describe service('zabbix-agent') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

#:todo
server_name=''
describe port(server_name, 10050), :skip do
  it { should be_listening }
end
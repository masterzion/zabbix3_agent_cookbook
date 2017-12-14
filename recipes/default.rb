#
# Cookbook:: zabbix3_agent_cookbook
# Recipe:: default
#
# Author:: Jairo Moreno (<master.zion@gmail.com>)
#
# Copyright:: 2017, Jairo Moreno, All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#server name
server_name='127.0.0.1' # <<<<< change this

#node name
host_name=Chef::Config[:node_name];


#install dirs
pkg_prefix = '/usr/local/'
pkg_dir = pkg_prefix +'zabbix/'
logfile='/var/log/zabbix_agentd.log'
pid_file='/run/zabbix/zabbix_agentd.pid'
pid_dir='/run/zabbix/'


#source url
if node['kernel']['machine'] == "x86_64"
  pkg_url = "https://www.zabbix.com/downloads/3.2.7/zabbix_agents_3.2.7.linux2_6.amd64.tar.gz"
else
  pkg_url = "https://www.zabbix.com/downloads/3.2.7/zabbix_agents_3.2.7.linux2_6.i386.tar.gz"
end

# service dir
case node['platform']
when 'debian', 'ubuntu'
  sys_service_dir = '/etc/systemd/system/'
  service_src = 'zabbix-agent.service.erb'
when 'redhat', 'centos', 'fedora'
  sys_service_dir = '/usr/lib/systemd/system/'
  service_src = 'zabbix-agent.service.erb'
when 'amazon'  
   service_src = 'zabbix-agent_aws.erb'
   sys_service_dir = '/etc/init.d/'
end


#Create pkg dir
directory pkg_dir do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end


#download and uncompress
tar_extract pkg_url do
  target_dir pkg_dir
end


#create /etc link
link '/etc/zabbix' do
    to pkg_dir+"conf"
    link_type :symbolic
    action :create
end


# install bin files
link '/sbin/zabbix_agentd' do
  to pkg_dir+'sbin/zabbix_agentd'
end

link '/bin/zabbix_get' do
  to pkg_dir+'bin/zabbix_get'
end

link '/bin/zabbix_sender' do
  to pkg_dir+'bin/zabbix_sender'
end

# create user
user 'zabbix' do
end


# rename original config file
file "/etc/zabbix/zabbix_agentd.conf.orig" do
  owner 'root'
  group 'root'
  mode 0755
  content lazy { ::File.open("/etc/zabbix/zabbix_agentd.conf").read }
  action :create
end

#create config file
template '/etc/zabbix/zabbix_agentd.conf' do
	owner 'root'
	group 'root'
	mode '755'
	source 'zabbix_agentd.conf.erb'
	variables(
		:host_name => host_name,
		:server_name => server_name,
		:log_file => logfile,
		:pid_file => pid_file,
	)
end

# create service file
template sys_service_dir+'zabbix-agent.service' do
	owner 'root'
	group 'root'
	mode '755'
	source service_src
	variables(
		:log_file => logfile,
		:pid_file => pid_file,
	)
end


#create log file
file logfile do
	owner 'zabbix'
	group 'root'
	mode '755'
end

file logfile do
	owner 'zabbix'
	group 'root'
	mode '755'
	action :create
end


#create pid file
directory pid_dir do
  owner 'zabbix'
  group 'root'
  mode '0755'
  action :create
end

file pid_file do
	owner 'zabbix'
	group 'root'
	mode '755'
	action :create
end

puts node

# :todo
#case node["platform"]
#	when "ubuntu"
#		if node["platform\_version"].to\_f <= 16.04
#			link '/etc/init/zabbix-agent.service.conf' do
#			  to pkg_dir+"conf/zabbix_agentd.conf"
#			end
#		end
#	end


#start the service
service 'zabbix-agent.service' do
  action [ :enable, :start ]
  retries 3
end

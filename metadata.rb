name 'zabbix3_agent_cookbook'
maintainer 'jairo moreno (master_zion)'
maintainer_email 'master.zion@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures zabbix3_agent_cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)
depends "tar", ">= 2.1.1"
source_url 'https://github.com/masterzion/zabbix3_agent_cookbook'
issues_url 'https://github.com/masterzion/zabbix3_agent_cookbook/issues'


supports 'ubuntu', '>= 16.04'
supports 'centos', '>= 7'
supports 'debian', '>= 8'
supports 'amazon'

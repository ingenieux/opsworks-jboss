# Copyright 2013 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not
# use this file except in compliance with the License. A copy of the License is
# located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on
# an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
# or implied. See the License for the specific language governing permissions
# and limitations under the License.

include_recipe 'jboss::apache'

jboss_home = node['jboss']['jboss_home']
jboss_user = node['jboss']['jboss_user']

tarball_name = node['jboss']['dl_url'].
  split('/')[-1].
  sub!('.tar.gz', '')
path_arr = jboss_home.split('/')
path_arr.delete_at(-1)
jboss_parent = path_arr.join('/')

user jboss_user do
  comment "JBoss User"
  action :create
  home "/home/jboss"
  supports :manage_home => true
end

directory jboss_parent do
  group jboss_user
  owner jboss_user
  mode "0755"
  recursive true
  action :create
end

# get files
bash "put_files" do
  code <<-EOH
  set +x
  cd /tmp
  if [ ! -f #{tarball_name}.tar.gz ]; then
    wget -c #{node['jboss']['dl_url']}
  fi

  if [ ! -d #{jboss_home} ]; then  
    tar xvzf #{tarball_name}.tar.gz -C #{jboss_parent}
    chown -R jboss:jboss #{jboss_parent}
    mv #{jboss_parent}/#{tarball_name} #{jboss_home}
  fi
  EOH
end

%w{ domain standalone }.each do |path|
  file("#{jboss_home}/#{path}/configuration/mgmt-users.properties") { action :delete }

  file "#{jboss_home}/#{path}/configuration/mgmt-users.properties" do
    content "# DO NOT EDIT - AUTOMAGICALLY GENERATED
" + node['jboss']['jboss_admins']
    owner jboss_user
    group jboss_user
    mode  "0640"
    action :create
  end
end

# template init file
template "/etc/init/jboss.conf" do
  source "init_upstart.erb"
  mode "0755"
  owner "root"
  group "root"
end

template "#{jboss_home}/bin/standalone.conf" do
  source "standalone.erb"
  mode "0755"
  owner jboss_user
  group jboss_user
end

template "#{jboss_home}/standalone/configuration/standalone.xml" do
  source "standalone.xml.erb"
  mode "0755"
  owner jboss_user
  group jboss_user
end

# template jboss-log4j.xml


# link ::File.join(node['tomcat']['lib_dir'], node['tomcat']['mysql_connector_jar']) do
#   to ::File.join(node['tomcat']['java_dir'], node['tomcat']['mysql_connector_jar'])
#   action :create
# end

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

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end

  current_dir = ::File.join(deploy[:deploy_to], 'current')

  # bash do
  #   code <<-eoh
  #
  #   eoh
  # end

  # webapp_dir = ::File.join(node['tomcat']['webapps_base_dir'], deploy[:document_root].blank? ? application : deploy[:document_root])

  # # opsworks_deploy creates some stub dirs, which are not needed for typical webapps
  # ruby_block "remove unnecessary directory entries in #{current_dir}" do
  #   block do
  #     node['tomcat']['webapps_dir_entries_to_delete'].each do |dir_entry|
  #       ::FileUtils.rm_rf(::File.join(current_dir, dir_entry), :secure => true)
  #     end
  #   end
  # end

  suffix = File.exist?(File.join(current_dir, 'WEB-INF')) ? '.war' : '.ear'

  webapp_dir = ::File.join(node['jboss']['jboss_home'], 'standalone', 'deployments', application + suffix)

  link webapp_dir do
    to current_dir
    action :create
  end

  # file(::File.join(webapp_dir, '.dodeploy')) { action :dodeploy }
end

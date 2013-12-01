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



default['jboss']['jboss_home'] = "/home/jboss/share/jboss/default"
default['jboss']['version'] = "7.1.1"
default['jboss']['dl_url'] = "http://download.jboss.org/jbossas/7.1/jboss-as-7.1.1.Final/jboss-as-7.1.1.Final.tar.gz"
default['jboss']['jboss_user'] = "jboss"

default["jboss"]["bind"]["public"] = "0.0.0.0"
default["jboss"]["bind"]["management"] = "0.0.0.0"
default["jboss"]["bind"]["unsecure"] = "0.0.0.0"

## For more details on this format, see 

default['jboss']['jboss_admins'] = ""

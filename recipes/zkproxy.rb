##
#  Copyright (c) 2014, Facebook, Inc.
#  All rights reserved.
#
#  This source code is licensed under the BSD-style license found in the
#  LICENSE file in the root directory of this source tree. An additional grant
#  of patent rights can be found in the PATENTS file in the same directory.
##


package "iptables-persistent"
include_recipe "apt"

apt_package "iptables" do
    version "1.4.12-1ubuntu5"
end

=begin

This recipe assumes that your Zookeeper cluster is defined in a data bag.
For example, if you have a 5-node ZK cluster, you can have a databag that looks like this:
{
  "id": "ensembles",
  "ec2_zkneti": {
    "1": "54.208.175.130",
    "2": "54.208.104.158",
    "3": "54.208.161.225",
    "4": "54.208.175.128",
    "5": "54.208.143.128"
  },
  "zkneti": {
    "1": "10.21.34.65",
    "2": "10.21.105.57",
    "3": "10.21.159.3",
    "4": "10.21.42.78",
    "5": "10.21.69.177"
   }
}

The entries in ec2_zkneti are the Elastic IPs of the Zookeeper instances in VPC.
The entries in zkneti are the internal IPs of the Zookeeper instances in VPC.

=end

ensemble_config = data_bag_item("zookeeper", "ensembles")

# Set node[:zookeeper][:ensemble] to "ec2_zkneti" in the role/attributes of the proxy nodes
unsorted_ensemble_hosts = ensemble_config[node[:zookeeper][:ensemble]]
ensemble_hosts = unsorted_ensemble_hosts.sort_by { |k, v| k.to_i }

# This assumes that you have the index numbers in the databags as suffixes in your instance names
node_index = node.name.scan(/\d/)[0,1].join('').to_i
dest_ip = ensemble_hosts[node_index][1]

template "/tmp/iptables" do
    source "zkneti-proxy.iptables.erb"
    owner "root"
    group "root"
    mode 0644
    variables({
        :dest_ip => dest_ip
    })
end

execute "flush-all-nat-rules" do
    command "iptables-restore /tmp/iptables"
end

execute "save-iptables-rules" do
    command "iptables-save > /etc/iptables/rules.v4"
end

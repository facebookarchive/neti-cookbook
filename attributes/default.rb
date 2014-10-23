##
#  Copyright (c) 2014, Facebook, Inc.
#  All rights reserved.
#
#  This source code is licensed under the BSD-style license found in the
#  LICENSE file in the root directory of this source tree. An additional grant
#  of patent rights can be found in the PATENTS file in the same directory.
##

default[:neti][:ssh_whitelist] = [
    "XX.XX.XX.XX/18"
]
default[:neti][:ec2][:zk_hosts] = [
    "zkneti0-proxy-ue1a:2181",
    "zkneti1-proxy-ue1b:2181",
    "zkneti2-proxy-ue1e:2181",
    "zkneti3-proxy-ue1a:2181",
    "zkneti4-proxy-ue1b:2181"
]
default[:neti][:vpc][:zk_hosts] = [
    "10.21.34.65:2181",
    "10.21.105.57:2181",
    "10.21.159.3:2181",
    "10.21.16.127:2181",
    "10.21.69.177:2181"
]
default[:neti][:nat_overrides] = {}
default[:neti][:open_ports] = []
default[:neti][:bin] = "/usr/local/bin/neti"
default[:neti][:log_file] = "/var/log/neti.log"
default[:neti][:table_files_path] = "/tmp/neti"
default[:neti][:reject_all] = "true"
default[:neti][:aws_key] = "XXXXXXXXXXXXXXXXXX"
default[:neti][:aws_secret_key] = "XXXXXXXXXXXXXXXXXX"
default[:neti][:zk_update_interval_path] = "interval"
default[:neti][:zk_max_change_threshold_path] = "maxchange"
default[:neti][:zk_prefix] = "/neti"
default[:neti][:zk_iptoid_node] = "ip-to-id"
default[:neti][:zk_idtoip_node] = "id-to-ip"
default[:neti][:zk_ip_map_node] = "ip-map"
default[:neti][:overlay_subnet] = "192.168.0.0/18"
default[:neti][:overlay_ip_cache_file_path] = "/var/cache/neti_overlay_ip"

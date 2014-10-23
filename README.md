# Neti-cookbook
Cookbook to setup Neti (EC2-VPC firewall sync).

## Requirements
Currently, Neti works on Ubuntu/Debian, but should work on many more platforms with a few tweaks to the package management.  Also, if you don't use AWS, you can just stop reading now...not even sure how you got here. You'll need a set of AWS keys that allows instance metadata modification. You will need to create a Zookeeper cluster, so familiarity with Zookeeper s necessary, but all that is needed is a very basic installation.

## Attributes
These attributes set up the Neti config file for you:
* ssh_whitelist: The IPs that you want Neti to always allow on port 22, regardless of any firewall
* zk_hosts: 
    * ec2: hostname/ip and zookeeper port of zk proxies in EC2
    * vpc: hostname/ip and zookeeper port of zookeeper hosts in VPC
* nat_overrides: hash of source and destination ips for overriding Neti's NAT manipulation
* open_ports: ports to open to all access on the host
* bin: location of Neti bin script
* log_file: location of log file
* table_files_path: location to store the iptables-save files for restoration
* reject_all: Whether or not to reject all traffic that is not specifically specified in the iptables rules (when you open up access to all public AWS ranges)
* aws_key: your aws key
* aws_secret_key: your aws secret key
* zk_update_interval_path: zookeeper node to store interval value
* zk_max_change_threshold_path: zookeeper node to store max change threshold (how many rules can be changed at once...safeguard)
* zk_prefix: zookeeper node prefix for all neti data
* zk_iptoid_node: zookeeper node for map
* zk_idtoip_node: zookeeper node for map
* zk_ip_map_node: zookeeper node for map
* overlay_subnet: subnet to pull overlay addresses from
* overlay_ip_cache_file_path: path for file cache of ips

## How Neti works
See <blog post>

See the CONTRIBUTING file for how to help out.

## License
Neti is BSD-licensed. We also provide an additional patent grant.

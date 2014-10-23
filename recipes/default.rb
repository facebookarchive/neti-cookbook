##
#  Copyright (c) 2014, Facebook, Inc.
#  All rights reserved.
#
#  This source code is licensed under the BSD-style license found in the
#  LICENSE file in the root directory of this source tree. An additional grant
#  of patent rights can be found in the PATENTS file in the same directory.
##


include_recipe "python"
include_recipe "apt"


if node["platform_version"].to_f == 11.04
    apt_repository "iptables-ppa" do
      uri "http://ppa.launchpad.net/dns/misc/ubuntu"
      distribution node["lsb"]["codename"]
      components ["main"]
      deb_src true
      keyserver "keyserver.ubuntu.com"
      key "479B857B"
      action :remove
    end
    apt_package "iptables" do
        version "1.4.10-1ubuntu1"
        options "--force-yes"
    end
    apt_package "linux-headers-2.6.38-8-virtual"
    apt_package "xtables-addons-common-1.32"
    execute "apt-get -f install"
    apt_package "module-assistant"
    execute "install xtables modules" do
        command "module-assistant auto-install xtables-addons-source -t"
    end
else
    apt_package "iptables" do
        version "1.4.12-1ubuntu5"
    end
    apt_package "ipset"
end

directory "/etc/neti" do
    owner "root"
    group "root"
    mode 0755
end

directory node[:neti][:table_files_path] do
    owner "root"
    group "root"
    mode 0755
    recursive true
end

template "/etc/neti/neti.yml" do
    source "neti.yml.erb"
    owner "root"
    group "root"
    mode 0644
end

template "/etc/init/neti.conf" do
    source "neti.upstart.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

python_pip "requests" do
    version "0.11.2"
end

python_pip "kazoo" do
    version "1.3.1"
end

python_pip "ipaddress" do
    version "1.0.6"
end

python_pip "boto" do
    version "2.3.0"
end

python_pip "pyyaml" do
    version "3.11"
end

# assuming that the pip package is there.
python_pip "neti" do
    version "1.1.7"
end

service "neti" do
    provider Chef::Provider::Service::Upstart
    enabled true
    running true
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
end

execute "prime conntrack" do
    command "modprobe ip_conntrack && echo #{node[:sysctl][:net][:netfilter][:nf_conntrack_max]} > /proc/sys/net/netfilter/nf_conntrack_max"
end

cookbook_file "neti-get-overlay-ip" do
    path "/usr/local/bin/neti-get-overlay-ip"
    mode 0755
    action :create
end

execute "cache neti overlay IP" do
    path = node[:neti][:overlay_ip_cache_file_path]
    command "/usr/local/bin/neti-get-overlay-ip > #{path}"
    only_if { not ::File.exists?(path) or ::File.zero?(path) }
end

ruby_block "read neti overlay IP into chef environment" do
    block do
        overlay_ip = ::File.read(node[:neti][:overlay_ip_cache_file_path])
        node[:neti][:overlay_ip] = overlay_ip.strip
    end
end

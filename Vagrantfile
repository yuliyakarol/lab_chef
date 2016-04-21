# -*- mode: ruby -*-
# vi: set ft=ruby :

$ip1="192.168.33.10"
$ip2="192.168.33.11"
$dir="d:/lab_chef"
$script = <<EOF
sudo -i
yum update
yum install wget curl -y
yum install gcc-c++ patch readline readline-devel zlib zlib-devel
yum install libyaml-devel libffi-devel openssl-devel make
yum install bzip2 autoconf automake libtool bison iconv-devel sqlite-devel
curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh
rvm reload
rvm requirements run
rvm install 2.2.4
rvm use 2.2.4 --default


rpm -ivh chef-12.9.38-1.el6.x86_64.rpm

rpm -ivh chefdk-0.12.0-1.el6.x86_64.rpm

mkdir -p /root/{.chef,cookbooks,.ssh}
knife configure initial

cat > /root/.chef/solo.rb <<FL
log_level :debug
file_cache_path "/root/.chef/"
cookbook_path "/lab_chef/cookbooks"
json_attribs "/root/.chef/runlist.json"
log_location "/lab_chef/chef-solo.log"
FL

cd /lab_chef/cookbooks/nginx
berks install

berks package
tar -xf $(ls | grep *tar.gz) -C /lab_chef/
echo Create runlist file
cat > /root/.chef/runlist.json <<FL
{ 
"run_list": ["recipe[nginx::default]", "recipe[iptables::default]"],
  "nginx": {"default_root":"/usr/share/nginx/html"} 
} 
FL
echo Run chef-solo
chef-solo -c /root/.chef/solo.rb
EOF


Vagrant.configure(2) do |config|

  config.vm.define "virtual1" do |v1|
    v1.vm.box = "bento/centos-6.7"
    v1.vm.network "private_network", ip: $ip1
    v1.vm.hostname = "virtual1.test.by"
    v1.vm.provider "virtualbox1" do |vb1|
		vb1.name = "virtual1"
		vb1.customize ["modifyvm", :id, "--memory", 1024] 
		vb1.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end
    v1.vm.synced_folder $dir, "/lab_chef"
    v1.vm.provision "shell", inline: $script
	
  end
  
    config.vm.define "virtual2" do |v2|
    v2.vm.box = "bento/centos-6.7"
    v2.vm.network "private_network", ip: $ip2
    v2.vm.hostname = "virtual2.test.by"
    v2.vm.provider "virtualbox2" do |vb2|
		vb2.name = "virtual2"
		vb2.customize ["modifyvm", :id, "--memory", 1024] 
		vb2.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	end
    config.vm.provision "chef_solo" do |chef|
      chef.cookbooks_path = $dir+"/cookbooks"
      chef.add_recipe "nginx::default"
      chef.add_recipe "iptables::default"
      chef.json = {
        "nginx" => {
         "default_root" => "/usr/lab_chef/nginx/html"
        }
      }
    end
    v2.vm.synced_folder $dir, "/lab_chef"
  end
end

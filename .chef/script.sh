<<EOF
echo updating the already-installed Ubuntu packages
sudo apt-get update
sudo apt-get safe-upgrade
sudo apt-get install ruby

echo installing chef client
sudo gem update --no-rdoc --no-ri
sudo gem install chef --no-ri --no-rdoc

echo installing chefdk
sudo wget https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.12.0-1_amd64.deb
sudo dpkg -i chefdk_*.deb
sudo rm chefdk_*.deb

echo create directories for chef-repo and ssh-keys
cd /root
sudo chef generate repo chef-repo
mkdir -p /root/chef-repo/{.chef,cookbooks,.ssh}

echo create solo.rb file
cat > /root/chef-repo/.chef/solo.rb <<FL
log_level :debug
file_cache_path "/root/chef-repo/.chef/"
cookbook_path "/root/chef-repo/cookbooks"
json_attribs "/root/chef-repo/.chef/runlist.json"
log_location "/root/chef-repo/chef-solo.log"
FL
echo add the RSA Private Keys
scp vagrant@192.168.33.10:~/.chef/*.pem ~/chef-repo/.chef/

echo list pem keys
ls ~/chef-repo/.chef

echo cd to nginx and run berks install
cd /lab_chef/cookbooks/nginx
berks install
echo unpack archive 
berks package
tar -xf $(ls | grep *tar.gz) -C /lab_chef/

echo Create runlist file
cat > /root/chef-repo/.chef/runlist.json <<FL
{ 
"run_list": ["recipe[nginx::default]", "recipe[iptables::default]"],
  "nginx": {"default_root":"/usr/lab_chef/nginx/html"} 
} 
FL
echo Run chef-solo
chef-solo -c /root/chef-repo/.chef/solo.rb
EOF
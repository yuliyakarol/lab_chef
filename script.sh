<<EOF
echo updating the already-installed Ubuntu packages
sudo -i
 apt-get update
 apt-get safe-upgrade
 apt-get install ruby

echo installing chef client
 gem update --no-rdoc --no-ri
 gem install chef --no-ri --no-rdoc

echo installing chefdk
 wget https://packages.chef.io/stable/ubuntu/12.04/chefdk_0.12.0-1_amd64.deb
 dpkg -i chefdk_*.deb
 rm chefdk_*.deb

echo create directories for chef-repo and ssh-keys
 mkdir -p /root/{.chef,cookbooks,.ssh}

echo create solo.rb file
cat > /root/.chef/solo.rb <<FL
log_level :debug
file_cache_path "/root/.chef/"
cookbook_path "/lab_chef/cookbooks"
json_attribs "/root/.chef/runlist.json"
log_location "/lab_chef/chef-solo.log"
FL


echo cd to nginx and run berks install
cd /lab_chef/cookbooks/nginx
berks install
echo unpack archive 
berks package
tar -xf $(ls | grep *tar.gz) -C /lab_chef/

echo Create runlist file
cat > /root/.chef/runlist.json <<FL
{ 
"run_list": ["recipe[nginx::default]", "recipe[iptables::default]"],
  "nginx": {"default_root":"/usr/lab_chef/nginx/html"} 
} 
FL
echo Run chef-solo
chef-solo -c /root/.chef/solo.rb
EOF
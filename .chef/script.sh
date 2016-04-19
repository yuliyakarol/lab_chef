<<EOF
echo Installing Chef client
rpm -ivh chef-12.9.38-1.el6.x86_64.rpm
echo Installing Chef SDK
rpm -ivh chefdk-0.12.0-1.el6.x86_64.rpm
echo Create Directories for chef and ssh-keys
mkdir -p /root/{.chef,cookbooks,.ssh}
echo Create solo.rb file
cat > /root/.chef/solo.rb <<FL
log_level :debug
file_cache_path "/root/.chef/"
cookbook_path "/lab_chef/chef-courses/cookbooks"
json_attribs "/root/.chef/runlist.json"
log_location "/lab_chef/chef-courses/chef-solo.log"
FL
echo cd to nginx and run berks install
cd /lab_chef/chef-courses/cookbooks/nginx
berks install
echo unpack archive 
berks package
tar -xf $(ls | grep *tar.gz) -C /lab_chef/chef-courses/
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
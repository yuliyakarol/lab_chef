# lab_chef


1. Setup vagrant box and install chef-solo(please use basic boxes without preinstalled chef client) Download chef client from http://www.getchef.com/chef/install/ and install package. Download ChefDK and install http://www.getchef.com/downloads/chef-dk/

2. Configure knife

With your favorite editor: create ~/.chef/solo.rb

log_level :debug

file_cache_path "/root/.chef/"

cookbook_path "/root/chef_cookbooks"

json_attribs “/root/.chef/runlist.json"

Create files and folders mentioned in solo.rb config.

3. Download and install cookbooks (find and download nginx and iptables) from http://community.opscode.com/cookbooks/ to "/root/chef_cookbooks"

Hint: Better to use git repos.

Navigate to nginx cookbook, it has dependencies you may see it in its metadata.rb file.

We will use Berkshelf to download dependent cookbooks

berks install

#you should see bunch of cookbooks located in ~/ .berkshelf

# now we need to transfer them to our repo

berks package

# Cookbook(s) packaged to /root/cookbooks/nginx/cookbooks-1399822646.tar.gz

tar -xf /root/cookbooks/nginx/cookbooks-1399822646.tar.gz -C /root/

4. Create run list which contain recipes from downloaded cookbooks.

To ensure that only the recipes that you want to test are tested, include them in the node's run list via a JSON file. It looks like this:

{

"run_list": ["recipe[nginx::default]", "recipe[iptables::default]"],

"nginx": {"default_root":"/usr/share/nginx/html"}

}

We will install nginx iptables and override default nginx root to match path defined in Ubuntu nginx package by default.

5. Run create run config for chef-solo and apply runlist to VM. This should install configure and launc nginx on port 80.

chef-solo -c /root/.chef/solo.rb 
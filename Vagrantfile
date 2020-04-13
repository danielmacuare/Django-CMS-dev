Vagrant.configure("2") do |config|    

  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 80, host: 8880, host_ip: "127.0.0.1"
  config.vm.synced_folder "./shared/", "/vagrant_data/"
  config.vm.provision :shell, :path => "provisioning.sh"
  
  # https://github.com/hashicorp/vagrant/issues/5059
  config.ssh.insert_key = false

end

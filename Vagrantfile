Vagrant.configure("2") do |config|    

  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 80, host: 8880, host_ip: "127.0.0.1"
  config.vm.synced_folder "./shared/", "/vagrant_data/"
  config.vm.provision :shell, :path => "provisioning.sh"
  
  # https://github.com/hashicorp/vagrant/issues/5059
  config.ssh.insert_key = false

  # To Disable the startup log file https://superuser.com/questions/1354068/how-can-i-relocate-or-disable-the-virtualbox-logfile-when-starting-a-vm-from-vag
  config.vm.provider "virtualbox" do |vb|
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
  end
end

disk = './ZFSDisk.vdi'

Vagrant.configure("2") do |config|    
  # https://technology.amis.nl/2019/03/23/6-tips-to-make-your-life-with-vagrant-even-better/
  unless Vagrant.has_plugin?("vagrant-disksize")
    puts 'Installing vagrant-disksize Plugin...'
    system('vagrant plugin install vagrant-disksize')
  end
  
  unless Vagrant.has_plugin?("vagrant-vbguest")
    puts 'Installing vagrant-vbguest Plugin...'
    system('vagrant plugin install vagrant-vbguest')
  end
  
  unless Vagrant.has_plugin?("vagrant-reload")
    puts 'Installing vagrant-reload Plugin...'
    system('vagrant plugin install vagrant-reload')
  end

  config.vm.box = "ubuntu/bionic64"
  config.vm.network "forwarded_port", guest: 80, host: 8880, host_ip: "127.0.0.1"
  config.vm.synced_folder "./shared/", "/vagrant_data/"
  config.vm.provision :shell, :path => "provisioning.sh"



  # https://github.com/hashicorp/vagrant/issues/5059
  config.ssh.insert_key = false

  config.vm.provider "virtualbox" do |vb|
    # To Disable the startup log file https://superuser.com/questions/1354068/how-can-i-relocate-or-disable-the-virtualbox-logfile-when-starting-a-vm-from-vag
    vb.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]

    # Create a 2nd Drive to be used by ZFS.
    # https://stackoverflow.com/questions/27501019/vb-customize-storageattach-mounts-my-disk-first-time-but-changes-are-lost-aft
    unless File.exist?(disk)
        vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 10 * 1024]
    end
    vb.customize ['storageattach', :id,  '--storagectl', 'SCSI', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', disk]

  end
end

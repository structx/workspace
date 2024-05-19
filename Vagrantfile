
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"

  config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  config.ssh.forward_agent = true
  config.ssh.insert_key = false
  config.ssh.private_key_path = [ "~/.vagrant.d/insecure_private_key", "~/.ssh/id_rsa" ]

  config.vm.provider "virtualbox" do |vb|
  
    vb.memory = "1024"
  end

  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
  config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
  config.vm.provision "shell", inline: <<-SHELL
    cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
  SHELL

  config.vm.provision :shell, path: "bootstrap.sh"
end
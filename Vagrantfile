Vagrant.configure("2") do |config|
    servers=[
        {
          :hostname => "jenkins",
          :box => "bento/ubuntu-20.04",
          :ip => "192.168.56.50",
          :ssh_port => '2200',
          :script => 'scripts/jenkins-setup.sh'
        },
        {
          :hostname => "nexus",
          :box => "bento/ubuntu-20.04",
          :ip => "192.168.56.51",
          :ssh_port => '2201',
          :script => 'scripts/nexus-setup.sh'
        },
        {
          :hostname => "sonar",
          :box => "bento/ubuntu-20.04",
          :ip => "192.168.56.52",
          :ssh_port => '2202',
          :script => 'scripts/sonar-setup.sh'
        }
      ]

    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network :private_network, ip: machine[:ip]
            node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
            node.vm.provision "shell", path: machine[:script]
            node.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", 512]
                vb.customize ["modifyvm", :id, "--cpus", 1]
            end
        end
    end
end
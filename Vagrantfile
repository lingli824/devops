Vagrant.configure("2") do |config|
    servers=[
        {
          :hostname => "jenkins",
          :box => "bento/ubuntu-20.04",
          :ip => "192.168.56.50",
          :ssh_port => '2200',
          :http_port => '8080',
          :script => 'scripts/jenkins-setup.sh',
          :memory => '512',
          :cpu => '1'
        },
        {
          :hostname => "nexus",
          :box => "bento/ubuntu-20.04",
          :ip => "192.168.56.51",
          :ssh_port => '2201',
          :http_port => '8081',
          :script => 'scripts/nexus-setup.sh',
          :memory => '1024',
          :cpu => '2'
        },
        {
          :hostname => "sonar",
          :box => "bento/ubuntu-20.04",
          :ip => "192.168.56.52",
          :ssh_port => '2202',
          :http_port => '80',
          :script => 'scripts/sonar-setup.sh',
          :memory => '512',
          :cpu => '1'
        }
      ]

    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.hostname = machine[:hostname]
            node.vm.network :private_network, ip: machine[:ip]
            node.vm.network "forwarded_port", guest: 22, host: machine[:ssh_port], id: "ssh"
            node.vm.network "forwarded_port", guest: machine[:http_port], host: machine[:http_port], id: "http"
            node.vm.provision "shell", path: machine[:script]
            node.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", machine[:memory]]
                vb.customize ["modifyvm", :id, "--cpus", machine[:cpu]]
            end
        end
    end
end
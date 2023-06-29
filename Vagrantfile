# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "ansible" do |ansible|
    ansible.vm.box = "bento/centos-7"
    ansible.vm.hostname = "ansible"
    ansible.vm.network "private_network", ip: '192.168.44.9'

    ansible.vm.provider "virtualbox" do |v|
      v.name = "ProjectA-ansible"
      v.memory = 1024
     # v.linked_clone = true
    end
    ansible.vm.provision "shell", path: "./provision/install_ansible.sh"

    ansible.vm.provision "shell", privileged: false, inline: <<-SHELL
      ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa
    SHELL
  end
  
  config.vm.define "lb" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "lb"
      node.vm.network :private_network, ip: "192.168.44.10"
      node.vm.provider "virtualbox" do |v|
        v.name = "ProjectA-lb"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/loadbalancer.sh"
    
      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end
    
    config.vm.define "consulmaster" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "consulmaster"
      node.vm.network :private_network, ip: "192.168.44.15"
      node.vm.provider "virtualbox" do |v|
        v.name = "ProjectA-consulmaster"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/consul.sh"
    
      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

    config.vm.define "masterdb" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "masterdb"
      node.vm.network :private_network, ip: "192.168.44.13"
      node.vm.provider "virtualbox" do |v|
        v.name = "ProjectA-masterdb"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/database.sh"
    
      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

    config.vm.define "slavedb" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "slavedb"
      node.vm.network :private_network, ip: "192.168.44.14"
      node.vm.provider "virtualbox" do |v|
        v.name = "ProjectA-slavedb"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/database.sh"
    
      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

    config.vm.define "websocket" do |node|
      node.vm.box = "bento/ubuntu-22.04"
      node.vm.hostname = "websocket"
      node.vm.network :private_network, ip: "192.168.44.16"
      node.vm.provider "virtualbox" do |v|
        v.name = "ProjectA-websocket"
        v.memory = 2048
        v.cpus = 2
        v.linked_clone = true
      end
      node.vm.provision "shell", path: "./provision/websocket.sh"
    
      # the box generic/alpine might not have shared folders by default
      #node.vm.synced_folder "app/", "/var/www/html"
    end

    config.vm.define "webapp1" do |node|
        node.vm.box = "bento/ubuntu-22.04"
        node.vm.hostname = "webapp1"
        node.vm.network :private_network, ip: "192.168.44.11"
        node.vm.provider "virtualbox" do |v|
          v.name = "ProjectA-webapp1"
          v.memory = 2048
          v.cpus = 2
          v.linked_clone = true
        end
        node.vm.provision "shell", path: "./provision/app.sh", args: ["1"]
      
        # the box generic/alpine might not have shared folders by default
        #node.vm.synced_folder "app/", "/var/www/html"
      end
  
      config.vm.define "webapp2" do |node|
        node.vm.box = "bento/ubuntu-22.04"
        node.vm.hostname = "webapp2"
        node.vm.network :private_network, ip: "192.168.44.12"
        node.vm.provider "virtualbox" do |v|
          v.name = "ProjectA-webapp2"
          v.memory = 2048
          v.cpus = 2
          v.linked_clone = true
        end
        node.vm.provision "shell", path: "./provision/app.sh", args: ["2"]
      
        # the box generic/alpine might not have shared folders by default
        #node.vm.synced_folder "app/", "/var/www/html"
      end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

## Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
vagrantfile_api_version = "2"

## Select image
#vagrantfile_box_version = "archlinux/archlinux"
#vagrantfile_box_version = "generic/arch" # Hyper-V support

#vagrantfile_box_version = "debian/wheezy64"
#vagrantfile_box_version = "debian/stretch64"
#vagrantfile_box_version = "generic/debian9" # Hyper-V support

#vagrantfile_box_version = "ubuntu/xenial64"
vagrantfile_box_version = "ubuntu/bionic64"
#vagrantfile_box_version = "generic/ubuntu1810" # Hyper-V support

#vagrantfile_box_version = "centos/6"
#vagrantfile_box_version = "centos/7"
#vagrantfile_box_version = "generic/centos7" # Hyper-V support

Vagrant.configure(vagrantfile_api_version) do |config|

  ## Default VirtualBox VMs settings
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 1024]
    vb.customize ["modifyvm", :id, "--cpus", 2]
    vb.gui = false
  end

  ## Default vagrant settings
  config.vm.box_check_update = true

  ## Salt master VM settings
  config.vm.define :"salt-master01", primary: true do |master_config|

    master_config.vm.box = vagrantfile_box_version

    ## Configure VM name, host name and network
    master_config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", 4096]
      vb.customize ["modifyvm", :id, "--cpus", 4]
      vb.name = "salt-master01"
    end

    master_config.vm.host_name = "salt-master01"
    master_config.vm.hostname = "salt-master01"
    master_config.vm.network :private_network, ip: "192.168.254.5"

    ## Add shared folders with pillar, states and tests
    master_config.vm.synced_folder "salt-pillar", "/srv/pillar"
    master_config.vm.synced_folder "salt-states", "/srv/salt"

    ## Configure salt-master
    master_config.vm.provision :salt do |salt|
      ## Install and configure salt-master
      salt.bootstrap_options = "-P -F -c /tmp"
      salt.install_type = "stable"
      salt.version = '2019.2'
      salt.install_master = true
      salt.master_config = "resources/saltstack/etc/master"
      salt.master_key = "resources/saltstack/keys/master_minion.pem"
      salt.master_pub = "resources/saltstack/keys/master_minion.pub"
      salt.no_minion = false
      salt.minion_id= "salt-master01"
      salt.minion_config = "resources/saltstack/etc/minion1"
      salt.minion_key = "resources/saltstack/keys/minion1.pem"
      salt.minion_pub = "resources/saltstack/keys/minion1.pub"
      salt.verbose = true
      salt.verbose = true
      salt.colorize = true
      salt.log_level = "debug"
      salt.seed_master = {
          "salt-master01" => "resources/saltstack/keys/minion1.pub",
          "minion01" => "resources/saltstack/keys/minion2.pub"
      }
    end
  end
  
  config.vm.define :"minion01" do |minion_config|
    minion_config.vm.box = vagrantfile_box_version
    minion_config.vm.host_name = "minion01"
    minion_config.vm.network "private_network", ip: "192.168.254.130"

    minion_config.vm.provider :virtualbox do |vb|
      vb.name = "minion01"
    end

    minion_config.vm.provision :salt do |salt|
      salt.bootstrap_options = "-P -F -c /tmp"
      salt.install_type = "stable"
      salt.version = '2019.2'
      salt.install_master = false
      salt.no_minion = false
      salt.minion_config = "resources/saltstack/etc/minion2"
      salt.minion_key = "resources/saltstack/keys/minion2.pem"
      salt.minion_pub = "resources/saltstack/keys/minion2.pub"
      salt.minion_id = "minion01"
      salt.verbose = true
      salt.colorize = true
    end
  end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "oraclelinux/9-btrfs"
  config.vm.box_url = "https://oracle.github.io/vagrant-projects/boxes/oraclelinux/9-btrfs.json"
  config.vm.hostname = "vscoffline-test"

  config.ssh.key_type = :ecdsa521 # Requires Vagrant 2.4.1

  ############################################################################
  # Provider-specific configuration                                          #
  ############################################################################
  config.vm.provider "virtualbox" do |vb|
    # Set Name
    vb.name = "VSCOffline Testing - OEL9"

    # Display the VirtualBox GUI when booting the machine
    vb.gui = false
    
    # Set up VM options
    vb.customize ["modifyvm", :id, "--vm-process-priority", "normal"]
    vb.customize ["modifyvm", :id, "--graphiccontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--vram", "256"]
    vb.customize ["modifyvm", :id, "--clipboard-mode", "bidirectional"]
    vb.customize ["modifyvm", :id, "--draganddrop", "bidirectional"]
    vb.customize ["modifyvm", :id, "--usbxhci", "on"]
    vb.customize ["modifyvm", :id, "--audioin", "on"]
    vb.customize ["modifyvm", :id, "--audiocontroller", "hda"]
    vb.customize ["modifyvm", :id, "--vrde", "off"]
  end

  ############################################################################
  # Network provisioners                                                   #
  ############################################################################
  config.vm.network "forwarded_port", guest: 4443, host: 4443

  ############################################################################
  # File copy provisioners                                                   #
  ############################################################################
  config.vm.provision "file", source: "~/.ssh", destination: ".ssh"
  config.vm.provision "file", source: "~/.gitconfig", destination: ".gitconfig"

  ############################################################################
  # Synced folder provisioners                                                   #
  ############################################################################
  config.vm.synced_folder "./", "/home/vagrant/vscoffline", type: "rsync"

  ############################################################################
  # Shell script provisioner                                                 #
  ############################################################################
  config.vm.provision "shell", inline: <<-'SHELL'
    ############################################################################
    # Add Software                                                             #
    ############################################################################
    # Add EPEL
    echo -e "\nInstalling additional repos\n"
    dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
    curl -fsSL https://cli.github.com/packages/rpm/gh-cli.repo >\
      "/etc/yum.repos.d/github-cli.repo"
    echo
    /usr/bin/crb enable

    # Software Update
    echo -e "\nInstalling Updates\n"
    dnf update -y

    # echo -e "\nUpdating to Python 20\n"
    # dnf module -y reset python
    # dnf module -y enable python:3.16
    # dnf distro-sync -y

    # Install Container/Additional Software
    echo -e "\nInstalling additional software\n"
    dnf install -y pip podman skopeo podman-docker podman-compose \
      tmux tree git git-lfs gh rsync mkisofs isomd5sum 

    # Setup Rootless Podman
    echo -e "\nSetting up rootless podman"
    sysctl user.max_user_namespaces=15000
    sed -i 's/user.max_user_namespaces=0/user.max_user_namespaces=15000/i' /etc/sysctl.conf
    usermod --add-subuids 200000-201000 --add-subgids 200000-201000 vagrant
    groupadd -r docker
    usermod -aG docker vagrant
    touch /etc/containers/nodocker

    # Import .ssh to vagrant user
    echo -e "\nSetting up vagrant user .ssh"
    git config --global http.sslBackend openssl
    cat /home/vagrant/.ssh/id*.pub >> /home/vagrant/.ssh/authorized_keys
    cat /root/.ssh/id*.pub >> /root/.ssh/authorized_keys
    chown -R vagrant:vagrant /home/vagrant
    chmod -R 600 /home/vagrant/.ssh
    chmod 700 /home/vagrant/.ssh
    
    echo -e "\nDone Updating. Rebooting.\n"
  SHELL

  # Reboot to enable updates
  config.vm.provision 'shell', reboot: true

  # # Enable FIPS
  # config.vm.provision "shell", inline: <<-'SHELL'
  #   echo -e "\nEnabling FIPS\n"
  #   fips-mode-setup --enable
  # SHELL
    
  # # Reboot to enable FIPS
  # config.vm.provision 'shell', reboot: true
end

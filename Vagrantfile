# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

# IMPORT VAGRANT VARIABLES
payload="conf/#{ENV['_VAGRANT_CFG']}"

config_file=File.expand_path(File.join(File.dirname(__FILE__), payload))

puts "# CONFIG: #{payload}"
settings=YAML.load_file(config_file)

# SETTINGS BREAKDOWN
global=settings['global']
nodes=settings['nodes']
vagrant_provider=global['provider']

Vagrant.configure(global['api_version']) do |config|
    # install external plugins
    config.vagrant.plugins = global['plugins']

    # always use Vagrants insecure key
    config.ssh.insert_key = false
    config.vm.synced_folder ".", "/vagrant", disabled: true

    nodes.each do | group_name, group_config |
        (1..group_config['instances']).each do | i |
            config.vm.define vm_name = "%s-%01d" % [group_config['node_prefix'], i] do | node |
                node.vm.box = group_config['os']
                node.vm.hostname = vm_name
    
                node.vm.provider vagrant_provider do | vb |
                    vb.cpus = group_config['cpu']
                    vb.memory = group_config['memory']

                    ( \
                        vb.gui = group_config['gui']
                        vb.linked_clone = true
                        vb.customize ["modifyvm", :id, "--vram", "8"] # ubuntu defaults to 256 MB which is a waste of precious RAM
                        vb.customize [ "guestproperty", "set", :id, "--timesync-threshold", 10000 ] # Time Sync

                        # MOUNT FILES
                        group_config['mounts'].each do | mount |
                            node.vm.synced_folder mount['host'], mount['guest'],
                                type: "nfs", 
                                disabled: false,
                                linux__nfs_options: ['rw','fsid=1','sync','no_subtree_check','no_root_squash','insecure']
                                # sshfs_opts_append: "-o nonempty -o cache=no"
                        end
                    ) if vagrant_provider == "virtualbox"


                    # ADDITIONAL DISKS
                    driverletters = ('c'..'z').to_a
                    
                    (1..group_config['disks']['instances']).each do | disk_index |
                        # VirtualBox
                        ( \
                            disk = "data/disks/disk-#{i}-#{disk_index}"
                            # Create our own controller for consistency and to remove VM dependency
                            # unless File.exist?("data/disks/disk-#{disk_index}.vdi")
                            #     # Adding OSD Controller;
                            #     # once the first disk is there assuming we don't need to do this
                            #     vb.customize ['storagectl', :id,
                            #     '--name', 'OSD',
                            #     '--add', 'scsi']
                            # end
                            vb.customize ['createhd',
                                        '--filename', disk,                                    
                                        '--size', group_config['disks']['size'] * 1024 ] unless File.exist?("#{disk}.vdi")
                            vb.customize ['storageattach', :id,
                                            '--storagectl', 'SCSI',
                                            '--port', 2 + disk_index,
                                            '--device', 0,
                                            '--type', 'hdd',
                                            '--medium', "#{disk}.vdi"]
                        ) if vagrant_provider == "virtualbox"
                        # LibVirt
                        ( \
                        vb.storage :file, 
                            :size => group_config['disks']['size'] * 1024,
                            :type => 'raw' 
                        ) if vagrant_provider == "libvirt"
                    end if group_config['disks'].include? 'instances'
                end

                # NETWORK
                group_config['address'].each do | address |
                    ip = "#{address['network']}.#{i+address['host']}"
                    node.vm.network :private_network, ip: ip
                end                

                # BOOTSTRAP NODE
                node.vm.provision "shell", inline: group_config['bootstrap']
            end
        end
    end
end
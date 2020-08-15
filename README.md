# jc_vagrant
[![Travis](https://img.shields.io/travis/jesmigel/jc_vagrant.svg)](https://travis-ci.org/jesmigel/jc_vagrant)
Boilerplate repository for virtual machine deployment

# REQUIREMENTS
## Host Requirements:
| Product | Install Validation (CLI)| Sample Output |
| ------- |:------------------------| -------------:|
| [VirtualBox](https://www.virtualbox.org/) | VBoxManage --version | 6.0.14r133895 |
| [Vagrant](https://www.vagrantup.com/) | vagrant --version | Vagrant 2.2.9 |

## Purpose
| Product | Description |
| ------- | -----------:|
| [VirtualBox](https://www.virtualbox.org/) | Virtualisation tool to be used by Vagrant |
| [Vagrant](https://www.vagrantup.com/) | Provides automation and management of local and remote Virtual Machines |


# MAKEFILE COMMANDS
| COMMAND | DESCRIPTION |
| ------- | ----------- |
| validate | Validates the vagrant config and payload. |
| up | Similar to vagrant up |
| down | Similar to vagrant halt |
| status | Similar to vagrant status |
| clean | Similar to vagrant destroy. Cleans vagrant and data directories |


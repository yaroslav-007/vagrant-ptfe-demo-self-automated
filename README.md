# Installing Terraform Enterprise in demo mode and recovering it from snapshot 

In this project we will provide scripts to makes a clean auto-install of Terraform Enterprise in a Vagrant VM. In case of previous snapshots present, the script will recover from them.

## About Terraform Enterprise
Terraform Enterprise is on-prem version of Terraform Cloud. This means that it implements the functionality of Terraform Cloud in private managed and secured infrastructure with additional enterprise-grade architectural features like audit logging and SAML single sign-on.


### Prerequisites
 - Install VirtualBox:
Download and install accordingly to your OS as described here:
https://www.virtualbox.org/wiki/Downloads

 - Install Vagrant:
Download and install accordingly to your OS as described here:
https://www.vagrantup.com/downloads.html

 - This document assumes you have a license file:
```
license-file.rli
```
You point its location in `replicated.conf`

### Open a terminal


 OS system | Operation
 ------------ | -------------
| Windows | Start menu -> Run and type cmd |
| Linux  |Start terminal |
| macOS | Press Command - spacebar to launch Spotlight and type "Terminal," then double-click the search result. |

### Download this repo
- clone the repo locally
```
clone git@github.com:yaroslav-007/vagrant-ptfe-demo-self-automated.git
cd vagrant-ptfe-demo-self-automated
```

- vagrant up  to create and power on the system.
 ```
 vagrant up
 ```

This is a VM with Ubuntu 18.04.3 LTS and includes the required configuration:
https://www.terraform.io/docs/enterprise/before-installing/index.html#linux-instance



### Auto-Install Terraform Enterprise 

Install script will auto-install and when its done you will able to access `https://192.168.56.33.xip.io:8800/` with password that is set in replicated.conf.

### Make snapshot
Open a browser at location `https://192.168.56.33.xip.io:8800/`
On the top right you can initiate a snapshot by clicking on `Start Snapshot` 


### Destroy the installation preserving the snapshot and recover from it.

To simulate a new provided system containing previous made snapshot, we run the script `delete_all.sh`. From the terminal we run:

 - `vagrant ssh`
 - `sudo bash /vagrant/delete_all.sh`
 - `exit`
 - `vagrant reload`
 - `vagrant provision`
 
 When you run the last two commands, the Ubuntu VM will be restart and provision script will be run again. It will notice that there are snapshot present and will recover them. When finished you can open from browser: `https://192.168.56.33.xip.io:8800/`
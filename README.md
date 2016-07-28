README for Ansible 3 client demo:
=================================

Demo consists of 4 CentOS 7 Vagrant VMs.  Tested on Fedora 23 and vagrant-libvirt.

If there's demand VirtualBox boxes can be added.

Passwords for both root and vagrant user are "vagrant"
Ansible Tower login is admin / vagrant

**First:** Add the Ansible server and client boxes to vagrant: 

Download the Server Box from:

https://www.dropbox.com/s/o4l9ehniyoyz4ql/centos-7-server-anstower%3Avagrant-libvirt.box?dl=0

$ vagrant box add centos-7-server-anstower:vagrant-libvirt /<path_to>/centos-7-server-anstower:vagrant-libvirt.box

Either download client box first, or add directly from the URL:

$ vagrant box add centos-7-client:vagrant-libvirt https://dl.fedoraproject.org/pub/alt/purpleidea/vagrant/centos-7.2/centos-7.2.box


_**Note:** These boxes are fairly heavyweight and could be replaced with lighter.._

**Next:** Clone the Git repo to ~/vagrant and it should create 4 subdirs

- ansible-3-client-demo
- client1
- client2
- client3

**Start the Demo:**

$ cd ~/vagrant/ansible-3-client-demos 

$ ./ansibleup.sh

This starts all 4 VMs in serial, and copies a demo playbook to the ansible
server (it still requires you to answer the yes prompt if you've got
StrictHostChecking enabled in your /etc/ssh/ssh_config) so do that,
and enter the password for the vagrant user of "vagrant"..
then it spits out a list of the IPs of the Client machines.

Copy the IPs to the clipboard and ssh to the Ansible VM using vagrant ssh 
in the ans folder.  Then paste the client IPs to the end of the
/etc/ansible/hosts file

$ sudo vi /etc/ansible/hosts

Do it like this to show how ansible can operate on subsets, or "groups"
(IPs here are examples.. use your own):

[web]

192.168.121.30

192.168.121.46

[db]

192.168.121.47

No need to ssh-copy-id to clients as the clients' Vagrantfile takes care
of that

As user ansible (not root or passwordless ssh won't work), test it's working with:

$ ansible all -m ping

Proceed to show other Ansible ad-hoc commands such as using the command module:

$ ansible db -a "/usr/bin/hostname"

Privilege escalation:

$ ansible web -a "/usr/bin/whoami"

..followed by: 

$ ansible web -a "/usr/bin/whoami" -b

Gathering facts:

$ ansible db -m setup

.. And any other points of discussion you might want to address.

Then you can demo using a playbook to setup / remediate two webservers. First 
point a browser at one of the webservers IP address to prove there's nothing
running e.g:

http://192.168.121.80

Also run:

$ ansible web -a "systemctl status httpd"

192.168.121.80 | FAILED | rc=3 >>
● httpd.service
   Loaded: not-found (Reason: No such file or directory)
   Active: inactive (dead)

192.168.121.16 | FAILED | rc=3 >>
● httpd.service
   Loaded: not-found (Reason: No such file or directory)
   Active: inactive (dead)

Then run the demo playbook:

$ ansible-playbook /home/vagrant/demo_playbook.yml

After it completes run the tests again.

**The demo environment also has Tower installed:**

You can hit the UI on the IP of the Ansible server vm.  Login: admin / redhat
Then you just need to paste your license key in and start using Tower if you want to 
demo that.

Eg:  To show Tower I can:

- First stop the webservers by running:

$ ansible web -a "systemctl stop httpd" -b  (-b required as needs to be root)

- Go to URL and show stopped; then go to Tower

- Login as admin
- Set up credentials for root user on a machine - asking for password
- Setup credentials for my github acccount
- Setup an inventory of 2 webservers in group web (to match the playbook)
	- Create the inventory first, then within that
	- Create group "web" 1st then click on it and then add hosts
- Create a project and point it at my github demo - Wait for solid green status
- Create a job template, selecting the playbook
- Launch the job template clicking the rocket - enter VM root password of vagrant
- Watch it complete
- Check back pointing browser at IP of one of the webservers

At the end of the demo, exit back to your laptop host and in the ans folder, run:

$ ./ansibledown.sh

That will shut it all down.




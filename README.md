README for Ansible 3 client demo:
=================================

5th May 2016 - Note: Demo still in development.  I want to replace the boxes with some lighter
weight ones.

Demo consists of 4 CentOS 7 Vagrant VMs.  Tested on Fedora 23 and vagrant-libvirt.

If there's demand VirtualBox boxes can be added.

Passwords for both root and vagrant user are "vagrant"

**First:** Add the Ansible server and client boxes to vagrant:

vagrant box add centos-7-client:vagrant-libvirt _[URL Path to be added]_

vagrant box add centos-7-server-ansible:vagrant-libvirt _[URL Path to be added]_


**Next:** Clone the Git repo to ~/vagrant and it should create 4 subdirs

- ans
- client1
- client2
- client3

**Start the Demo:**

cd to ans and run ./ansibleup.sh

This starts all 4 VMs in serial, copies a demo playbook to the ansible
server (it still requires you to answer the yes prompt if you've got
StrictHostChecking enabled in your /etc/ssh/ssh_config) so do that,
and enter the password for the vagrant user of "vagrant"..
then it spits out a list of the IPs of the Client machines.

Copy the IPs to the clipboard and ssh to the Ansible VM using vagrant ssh 
in the ans folder.  Then past the client IPs to the end of the
\etc/ansible/hosts file.

Do it like this to show how ansible can operate on subsets, or "groups"
(IPs here are examples.. use your own):

[web]

192.168.121.30
192.168.121.46

[db]

192.168.121.47

No need to ssh-copy-id to clients as the clients' Vagrantfile takes care
of that

Test it's working with:

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

At the end of the demo, exit back to your laptop host and in the ans folder, run:

$ ./ansibledown.sh

That will shut it all down.




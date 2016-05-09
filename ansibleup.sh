#!/bin/bash
#
# Script to start up my 4 ansible demo VMs with Vagrant
#

ANSHOME=${HOME}/vagrant/ansible-3-client-demo

cd ${ANSHOME}
/usr/bin/vagrant up
cd ${ANSHOME}/client1/ 
/usr/bin/vagrant up
cd ${ANSHOME}/client2/ 
/usr/bin/vagrant up
cd ${ANSHOME}/client3/ 
/usr/bin/vagrant up
/bin/echo "Saving IP of client to ${ANSHOME}/vm_ips.out:"
vagrant ssh -c "ip -4 a sh dev eth0" | grep inet | cut -d "/" -f 1 | awk '{ print $2 }' > ${ANSHOME}/vm_ips.out
cd ${ANSHOME}/client2/ 
/bin/echo "Saving IP of client to ${ANSHOME}/vm_ips.out:"
vagrant ssh -c "ip -4 a sh dev eth0" | grep inet | cut -d "/" -f 1 | awk '{ print $2 }' >> ${ANSHOME}/vm_ips.out
cd ${ANSHOME}/client1/ 
/bin/echo "Saving IP of client to ${ANSHOME}/vm_ips.out:"
vagrant ssh -c "ip -4 a sh dev eth0" | grep inet | cut -d "/" -f 1 | awk '{ print $2 }' >> ${ANSHOME}/vm_ips.out
cd ${ANSHOME} 
#
/bin/echo "** Copying demo playbook to Ansible server VM **"

#
# Check sshpass installed as it's required below
#

/usr/bin/rpm -qa | grep sshpass

if [[ $? != 0 ]]; then
  /bin/echo " ** You need to install sshpass for the next part to work automatically **"
  /bin/echo " ** Run sudo dnf install -y sshpass / sudo yum install -y sshpass **"
  /bin/echo " ** and then re-run this script ** "
  ${ANSHOME}/ansibledown.sh
 exit 0
fi

ANSIP=`vagrant ssh -c "ip -4 a sh dev eth0" | grep inet | cut -d "/" -f 1 | awk '{ print $2 }'`

/bin/echo "vagrant" > ${ANSHOME}/vagrantpass
#
# Check you have an ssh public key before trying to copy it
#

ls ~/.ssh/id_rsa.pub

if [[ $? != 0 ]]; then
  /bin/echo " ** You need to have a default-named RSA public key created **"
  /bin/echo " ** Run ssh-keygen and accept the default to create ~/.ssh/id_rsa.pub **"
  /bin/echo " ** and then re-run this script ** "
  ${ANSHOME}/ansibledown.sh
 exit 0
fi

sshpass -f ${ANSHOME}/vagrantpass /usr/bin/ssh-copy-id -o StrictHostKeyChecking=no vagrant@${ANSIP}

scp ${ANSHOME}/playbooks/demo_playbook.yml vagrant@${ANSIP}:
/bin/rm ${ANSHOME}/vagrantpass
#
/bin/echo "** Here is the list of Client IPs **"
cat ${ANSHOME}/vm_ips.out

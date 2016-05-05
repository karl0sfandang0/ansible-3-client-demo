#!/bin/bash
#
# Script to destroy my 4 ansible demo VMs with Vagrant
#

ANSHOME=${HOME}/vagrant/ansible-3-client-demo

cd ${ANSHOME}
/usr/bin/vagrant destroy
cd ${ANSHOME}/client1/ 
/usr/bin/vagrant destroy
cd ${ANSHOME}/client2/ 
/usr/bin/vagrant destroy
cd ${ANSHOME}/client3/ 
/usr/bin/vagrant destroy

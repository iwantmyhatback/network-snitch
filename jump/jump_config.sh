#!/bin/bash

cd $(dirname $0)

# Check if an argument is passed to confirm that loaded directory is uploaded to server
if [ $# -eq 0 ]
then
echo " Script requires that you have copied the POPULATED ./credentials/jump to the JUMP server"
echo " Do this using the following command: scp -r /credentials/jump jumpUser@jump.ip.address:~ "
echo " If you have done this you can run the jump_config script by passing 'yes' to the script as an argument"
exit 1
fi

# Check that user has root access
if (( $EUID != 0 ))
then
  echo "You must run jump_config as root"
  exit 1
fi

# Confirm that initial upload requirement is met
if [ $1 != "yes" ]
then
echo "Invalid argument... run script with no arguments to get instructions"
exit 1
fi

# Create a non-root user for the jump server
echo "creating jumpuser account on this machine"
mkdir /home/jumpuser
mkdir /home/jumpuser/.ssh
useradd jumpuser -d /home/jumpuser
# Set jumpUser password
echo "Set a password for jumpuser"
passwd jumpuser
# Authorize home to login with a normal shell
echo "Setting jumpuser account rules"
cp ./server-auth/authorized_keys /home/jumpuser/.ssh/authorized_keys
chmod 644 /home/jumpuser/.ssh/authorized_keys
chown -R jumpuser:jumpuser /home/jumpuser
chsh -s /bin/bash jumpuser
usermod -aG sudo jumpuser

# Create no-privlege "dummy" user to prevent reverse access from a stolen device
echo "creating dummy account on this machine"
mkdir /home/dummy
mkdir /home/dummy/.ssh
useradd dummy -d /home/dummy
# Set dummy password
echo "Set a password for dummy"
passwd dummy
# Authorize dummy login, and prevent code execution
echo "Setting dummy account rules"
cp ./sever-auth/dummy/authorized_keys /home/dummy/.ssh/authorized_keys
chmod 644 /home/dummy/.ssh/authorized_keys
chown -R dummy:dummy /home/dummy
chsh -s /bin/false dummy

# Configure ssh server keys and universtal settings
echo "Setting universtal ssh rules and server keys"
mkdir /etc/ssh
cp ./server-key/ssh_host_ecdsa_key /etc/ssh/ssh_host_ecdsa_key
chmod 600 /etc/ssh/ssh_host_ecdsa_key
cp ./server-key/ssh_host_ecdsa_key.pub /etc/ssh/ssh_host_ecdsa_key.pub
chmod 644 /etc/ssh/ssh_host_ecdsa_key.pub
cp ./server-config/sshd_config /etc/ssh/sshd_config
chmod 644 /etc/ssh/sshd_config
chown -R root:root /etc/ssh

# Setup firewall
echo "Setting initial firewall rules"
iptables-restore < ./firewall/rules.v4
ip6tables-restore < ./firewall/rules.v6
echo "Installing persistent firewall and sudo"
apt install iptables-persistent sudo -y
mkdir /etc/iptables/
echo "Installing persistent firewall rules"
cp ./firewall/rules.v4 /etc/iptables
cp ./firewall/rules.v6 /etc/iptables


# Lock down setup files
echo "Cleaning Up"
chmod 600 ./server-key/ssh_host_ecdsa_key
chown root:root ./server-key/ssh_host_ecdsa_key

echo "............"
echo "............"
echo "... Done ..."
echo "............"
echo "............"
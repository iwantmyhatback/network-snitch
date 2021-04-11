# Network Snitch

<br>
This repo is designed to automate the setup process for creation of a discrete device (Rapsberry Pi Zero) that can be deployed on any internal network and it will call back to the owner.  The device can easily be powered by a USB port on the router and the scripts were designed to use a wired connection through a microUSB-to-ethernet adaper (circumventing credential requirements).
<br>


## Procedure

### Optional 
1. If desired, then run the `change_snitch_port.sh` script and pass into it the desired snitch port

### Pre Setup 
1. Create a jump server (public facing intermediate). This script set was designed with raspberry pi's on a local network for proof-of-concept and has been modifiedfor use with an AWS (Amazon Web Services) EC2. When deploying the EC2 the setup requires a Linux image, (tested with Ubuntu and Debian), and make sure to set an additional incoming rule for: 
- Type: Custom TCP
- Protocol: TCP
- Port range: <Desired Port>
- Source Type: Anywhere
- Source: 0.0.0.0/0 

2. Flash a SD card with chosen Rasbian Image
3. Add an empty file named `ssh` to the `/boot` directory
4. Plug the Rasberry Pi Zero into your local router and determine its local ip address
5. Start up your "Home" machine (Linux or Mac)

### Script-Set Setup

1. *ON HOME:* Clone down the repository and `cd` into it

2. *ON HOME:* Run `generate_keys.sh` Make sure to reply "y" to each overwrite request

3. *ON HOME:* Run `home_config.sh` (note: the user can use `swap_creds.sh` to swap out your credentials between your original machine credentials and the snitch created credentials at any time)

4. *ON HOME:* Run `scp -i <serverKey.pem> -r jump <jumpServerUser>@<jumpServer.public.ipv4.address>:~` to transfer the necessary files to the jump server

5. *ON HOME:* Log into jump server using `ssh -i <serverKey.pem> <jumpServerUser>@<jumpServer.public.ipv4.address>`

6. *ON JUMP:* Change the `jump_config.sh` script to an executable using `chmod +x jump_config.sh`

7. *ON JUMP:* Run `jump-config.sh` as root and passing it the 'yes' parameter. Enter the requested user passwords and responding y/yes to any prompts (note: if not using AWS and custom firewall setup is needed, `jump_config.sh` contains a commented out block for setup of persistent rules. With that enabled be sure to respond yes to iptable prompts). System will reboot on completion.

8. *ON HOME:* Run `scp -r target pi@<pi.local.ip.address>:~` to transfer the necessary files to the target server (Raspberry Pi Zero)

9. *ON HOME:* Log into target server using `ssh pi@<pi.local.ip.address>`

10. *ON TARGET:* Change the `target_config.sh` script to an executable using `chmod +x target_config.sh`

11. *ON TARGET:* Run `target_config.sh` as root entering user passwords and responding y/yes to any requests. System will reboot

### Script-Set Setup Completed

To connect to the snitch from any network you run ` ssh -p <snitchPort> snitch@<jumpServer.public.ipv4.address>`

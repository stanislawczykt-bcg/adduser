function createsshuser()
{
  USER="$1"
  shift 
  SSH_PUBLIC_KEY="$*"
  
  PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
 
  # create a user with a random password
  adduser ${USER}
  echo ${USER}:${PASSWORD} | chpasswd
  
  # create a group for the created user
  groupadd -g 1010 cyberark-scanners
  usermod -a -G cyberark-scanners ${USER}
  
  # add the ssh public key
  su - ${USER} -c "umask 022 ; mkdir .ssh ; echo $SSH_PUBLIC_KEY >> .ssh/authorized_keys ; chown -R \$USER:\$USER /home/\$USER ; chmod 600 /home/\$USER/.ssh/authorized_keys ; chmod 700 /home/\$USER/.ssh  "
  
  
  # modify sudoers sudoers for the following commands: uname, ls, test, cat, lastlog, getent, grep, wc, find, xargs, ssh-keygen, echo, rm, date, hostname, ifconfig
  echo "%cyberark-scanners ALL=(ALL) NOPASSWD: /bin/cat, /bin/uname, /bin/ls, /bin/lastlog, /bin/getent, /bin/grep, /bin/wc, /bin/find, /bin/xargs, /bin/ssh-keygen, /bin/echo, /bin/rm, /bin/date, /bin/hostname, /sbin/ifconfig " >> /etc/sudoers.d/${USER}
  
  
}

createsshuser andzej ssh-rsa AAAAB3NzaC1...


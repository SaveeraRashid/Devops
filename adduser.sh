#! /bin/bash


users=()
paths=()
echo "Add users"
read  -a users
echo "add paths "
read -a paths
for  key in ${!users[@]};
do

echo "user " ${users[key]}
echo "path" ${users[key]}

#Check if username is empty
if [ -z "${users[key]}" ];
then
    echo "Username is empty"
    exit 1
fi

# Check if file location is empty
if [ -z "${paths[key]}" ];
then
    echo "Public key file path is empty"
    exit 1
fi

#Check if the user already exists
#if [ id -u "${users[key]}" >/dev/null 2>&1 ];
if [ $(getent passwd ${users[key]}) ];
then
    echo "User already exists"
    exit 1
fi


#creating new user

sudo adduser --disabled-password ${users[key]}

echo "Created USER" ${users[key]}

#Displaying contents of public key file

echo "Public Key File Contents:"
cat ${paths[key]}





#Allowing user to use sudo
echo "${users[key]} ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers


#Making new SSH Directory for new user
su ${users[key]} -c 'sudo  mkdir ~/.ssh'
echo "Made SSH Directory for" ${users[key]}

#Changing permission to issuing user

su ${users[key]} -c 'sudo chmod 700 ~/.ssh'
echo " Changed permission for SSH directory to user"
su ${users[key]} -c 'sudo chown '${users[key]}':'${users[key]}' ~/.ssh'

#Make Authrozed keys file
echo "Creating file Authorized_keys"
su ${users[key]} -c  'sudo nano  ~/.ssh/authorized_keys'

#Change ownership of auth file

echo "change ownership to user"
su ${users[key]} -c 'sudo chmod 600 ~/.ssh/authorized_keys'
su ${users[key]} -c 'sudo chown '${users[key]}':'${users[key]}' ~/.ssh/authorized_keys'

#append to authorized keys

echo "Appending Public key to Authorized_keys file"
su ${users[key]} -c 'sudo cat '${paths[key]}' >> ~/.ssh/authorized_keys'



done


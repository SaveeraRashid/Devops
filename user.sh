#! /bin/bash
lsb_release -is
users=()
paths=()
echo "Add users"
read  -a users
echo "add paths "
read -a paths

echo "Enter"
echo "1. Add User"
echo "2. Delete User"
read option

for  key in ${!users[@]};
do

echo "user " ${users[key]}
echo "path" ${paths[key]}

#Check if username is empty
        if [ -z "${users[key]}" ];
        then
                echo "Username is empty"
                exit 1
        fi

#Check if file location is empty
        if [ -z "${paths[key]}" ];
        then
                echo "Public key file path is empty"
                exit 1
        fi

#check release
        if [ $(lsb_release -is) = "Ubuntu" ];
        then
                echo "running if for"   $(lsb_release -is)
                #if you want to add user
                if [ $option == "1" ];
                then

                #Check if the user already exists

                        if [ $(getent passwd ${users[key]}) ];
						then
                                echo "User already exists"
                                exit 1
                        fi

                        #Displaying contents of public key file
                        echo "Public Key File Contents:"
                        cat ${paths[key]}

                        #creating new user
                        sudo adduser --disabled-password ${users[key]}
                        echo "Created USER" ${users[key]}

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
                        su ${users[key]} -c  'sudo touch  ~/.ssh/authorized_keys'

                        #Change ownership of auth file
                        echo "change ownership to user"
                        su ${users[key]} -c 'sudo chmod 600 ~/.ssh/authorized_keys'
                        su ${users[key]} -c 'sudo chown '${users[key]}':'${users[key]}' ~/.ssh/authorized_keys'
                        su ${users[key]} -c 'echo ~/.ssh/authorized_keys'

                        #append to authorized keys
                        echo "Appending Public key to Authorized_keys file"
                        su ${users[key]} -c 'sudo cat '${paths[key]}' >> ~/.ssh/authorized_keys'
                fi

        #if you want to delete user
                if [ $option == "2" ];
                then
                        if [ $(getent passwd ${users[key]}) ];
                        then
                                echo "User exists"
								 sudo deluser --remove-home ${users[key]}
                                echo "deleted"
                        else
                                echo "user doensot exsits"
                                exit 1
                        fi
                fi
        fi

        if [ $(lsb_release -is) = "CentOS" ];
        then

                #if you want to add user
                if [ $option == "1" ];
                then

                        #Check if the user already exists
                        if [ $(getent passwd ${users[key]}) ];
                        then
                                echo "User already exists"
                                exit 1
                        fi
#creating new user
                        sudo adduser ${users[key]}
                        sudo passwd ${users[key]}
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

                        #Make Authorized keys file
						echo "Creating file Authorized_keys"
                        su ${users[key]} -c  'sudo touch  ~/.ssh/authorized_keys'

                        #Change ownership of auth file
                        echo "change ownership to user"
                        su ${users[key]} -c 'sudo chmod -R go= '~/.ssh/authorized_keys''
                        su ${users[key]} -c 'sudo chown -R '${users[key]}':'${users[key]}' '~/.ssh/authorized_keys' '
                        su ${users[key]} -c 'sudo chmod 600 ~/.ssh/authorized_keys '

                        #append to authorized keys
                        echo "Appending Public key to Authorized_keys file"
                        su ${users[key]} -c 'sudo cat '${paths[key]}' >> ~/.ssh/authorized_keys '

                fi

                #if you want to delete user
                if [ $option == "2" ];
                then
                        if [ $(getent passwd ${users[key]}) ];
                        then
                                echo "User exists"
                                sudo userdel -r ${users[key]}
                                echo "deleted"
								else
                                echo "user doesnot exists"
                        exit 1
                        fi
                fi
        fi
done

								




						

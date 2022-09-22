# Repository is Devops
##Filename is adduser.sh 
##Description 
######This is a shell script file that takes user input of users and the path to public key file to create the new users and allow access to them. 
##Working 
######Download the file and run in a unix environment. Make the file executable.Run it by the either of the following command. 
```
sudo bash ./adduser.sh 
sudo bash -f ./adduser.sh 
```
######The script will ask for users. Add add many users as you want with a space between them as shown below. Press enter to finish entering the users. 
```
Add users: john torn ander
```
######Then it will prompt for the public key file location. Add key files as shown. 
```
/home/user/userpublicfile.pub 
/home/useruserpublicfile.pub 
```
######After that script will run on its own. It applied conditions to check if arguments are empty or if user exits. Then it will create the user with now password and stores the public key file to the authorized_keys file of the user. It allows user to use sudo without password by placing the entry in /etc/sudoers. At the end you will be able to access the users. 

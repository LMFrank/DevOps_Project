import getpass

user = getpass.getuser()
passwd = getpass.getpass('your password: ')
print(user, passwd)

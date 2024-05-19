# Decentralized Workspace

development environment infrastructure scripts using terraform.

## Dependencies

[VirtualBox](https://www.virtualbox.org/)

[Vagrant](https://www.vagrantup.com/)

## Setup 

Vagrant will facilitate setting up the development environmnet into an ubuntu instance.
The `bootstrap.sh` file will install all necessary tools for the environment. 

```bash
vagrant up
```

Once the box has been initialized you will need to download all the repositories

```bash
cd /vagrant
sudo chmod u+x bootstrap_cluster.sh
./bootstrap_cluster.sh
```

Set a local ssh configuration on your host machine to access the vagrant box. Assuming no values have been changed in the `Vagrantfile`
```bash
Host vagrant
    User vagrant
    Port 2222
    HostName localhost
    IdentityFile ~/.ssh/id_rsa
```

Using Vscode remote ssh [extension](https://code.visualstudio.com/docs/remote/ssh-tutorial) access can be gained into the vagrant box.
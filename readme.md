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

Once inside the container `cd /vagrant` and there is another bootstrap command that needs to be run. This command will download all repositories and any tooling that needs to be installed once the user is created. 

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

tee -a ~/.bashrc >>EOF
export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF

nvm install 20
node -v
npm -v

./bootstrap_cluster.sh
```

You will need to bring online the registry service and update the k3s cluster to use the registry service.

```
# start the registry service using terraform
cd /vagrant/tf/modules/registry
terraform apply --auto-approve

# copy the registries.yaml into `/etc/rancher/k3s/registries.yaml`
sudo tee /etc/rancher/k3s/registries.yaml <<EOF
mirrors:
  registry.structx.local:
    endpoint:
      - http://registry.structx.local:5000/v2
  docker.io:
    endoint: 
      - https://index.docker.io/v2
EOF

# restart k3s 
sudo systemctl restart k3s
```
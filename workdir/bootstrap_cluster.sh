
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

tee -a ~/.bashrc <<EOF
export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
source ~/.bashrc

nvm install 20
node -v
npm -v

# for contributing change repository to fork
git clone git@github.com:structx/ddns.git /home/vagrant/ddns
git clone git@github.com:structx/ledger-ui.git /home/vagrant/ledger-ui
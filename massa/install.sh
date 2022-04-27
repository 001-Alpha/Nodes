#!/bin/bash

echo "STARTIN INSTALLATION MASSA NODE"
curl -s https://raw.githubusercontent.com/001-Alpha/Main/master/alpha.sh | bash

sudo apt update
curl -s https://raw.githubusercontent.com/001-Alpha/Main/master/langs/install_rust.sh | bash

source $HOME/.cargo/env
sleep 1
rustup toolchain install nightly
rustup default nightly
cd $HOME

if [ ! -d $HOME/massa/ ]; then
	git clone https://github.com/massalabs/massa
	cd $HOME/massa && git checkout TEST.9.2

cd $HOME/massa/massa-node/

cargo build --release

sudo systemctl restart systemd-journald
sudo systemctl enable massa
sudo systemctl daemon-reload
sudo systemctl restart massa

cd $HOME/massa/massa-client/
cargo run -- --wallet wallet.dat wallet_generate_private_key

echo "alias client='cd $HOME/massa/massa-client/ && cargo run --release && cd'" >> ~/.profile
echo "alias clientw='cd $HOME/massa/massa-client/; cargo run -- --wallet wallet.dat; cd'" >> ~/.profile

cd $HOME
mkdir -p $HOME/backups
cp $HOME/massa/massa-node/config/node_privkey.key $HOME/backups/
cp $HOME/massa/massa-client/wallet.dat $HOME/backups/
if [ ! -e $HOME/massa_bk.tar.gz ]; then
	tar cvzf massa_bk.tar.gz backups
fi

curl -s https://raw.githubusercontent.com/razumv/helpers/main/massa/bootstrap-fix.sh | bash
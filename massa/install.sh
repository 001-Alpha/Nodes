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

cd massa/massa-node/
screen -S massa_node
RUST_BACKTRACE=full cargo run --release |& tee logs.txt


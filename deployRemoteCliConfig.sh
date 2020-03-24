#/bin/bash

for f in $(cat ~/shop*.lst); do scp remote-vimrc  $f:~/.vimrc ; done
for f in $(cat ~/shop*.lst); do scp remote-profile $f:~/.profile ; done

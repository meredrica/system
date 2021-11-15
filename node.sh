#!/bin/sh
sudo npm install -g \
	hueadm \ #lights
	nb.sh \ #notebook

# update completions for nb
"$(which nb)" completions install

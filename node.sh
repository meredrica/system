#!/bin/sh
npm install -g \
	nb.sh #notebook

# update completions for nb
"$(which nb)" completions install

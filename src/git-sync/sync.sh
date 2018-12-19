#!/bin/sh
if [ ! -f .git ]; then git init;
fi;

while true; do
	git pull https://github.com/igormelnikov/reddit.git microservices
	sleep 15
done

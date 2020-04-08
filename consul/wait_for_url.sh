#!/bin/bash

URL=$1

echo "Waiting for URL: $URL"
while [[ "$(curl --insecure -L -s -o /dev/null -w ''%{http_code}'' $URL)" != "200" ]]; do
    printf "."
    sleep 5;
done
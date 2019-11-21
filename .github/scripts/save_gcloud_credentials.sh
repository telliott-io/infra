#!/bin/sh

echo $GCLOUD_CREDENTIALS_BASE64 | base64 --decode > gcloud-credentials.json
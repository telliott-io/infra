#!/bin/bash

export SecretSigningCert=$(cat tls.crt)
export SecretSigningKey=$(cat tls.key)
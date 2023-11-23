#!/usr/bin/env bash

# Set the script to exit immediately if any command returns a non-zero exit status (error)
set -e

# Use grep to quietly check if the current hostname (obtained by 'cat /etc/hostname') 
# is already present in the /etc/hosts file
# The '-q' flag makes grep quiet, so it does not output anything
# The '-F' flag treats the string as a fixed string, not a regular expression
grep -qF "$(cat /etc/hostname)" /etc/hosts || \

# This line is executed if grep does not find the hostname in /etc/hosts (i.e., grep returns a non-zero exit status)
# 'echo' is used to print "127.0.0.1 [hostname]", and this output is then appended to /etc/hosts
# We use 'tee -a' for appending while also using 'sudo' to ensure we have the necessary permissions to modify /etc/hosts
echo "127.0.0.1 $(cat /etc/hostname)" | \
sudo tee -a /etc/hosts

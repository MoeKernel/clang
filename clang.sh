#!/bin/bash

# -----------------------------
# script created by
#     Akari Azusagawa © 2023
# ----------------------------- 

user="ZyCromerZ" # GitHub user.
date_=$(cat date_.txt) # updated clang version.
version_clang="22.0.0git"
version="22.0.0"
tc="$HOME/tc/clang-$version"
version="$version_clang-$date_-release"
clang_gz="Clang-$version_clang-$date_.tar.gz"
url="https://github.com/$user/Clang/releases/download/$version/$clang_gz"

output_file="$clang_gz"
destination_dir="$tc"

if [ -d "$destination_dir" ]; then
  echo "The directory '$destination_dir' already exists. Exiting script."
  exit 0
fi

if ! command -v curl &>/dev/null; then
  echo "The command 'curl' is not installed. Please install it to continue."
  sudo apt update -y 
  sudo apt install curl -y
  exit 1
fi

echo "Downloading $url..."
curl -LO "$url"

if [ $? -ne 0 ]; then
  echo "The download of the archive has failed."
  exit 1
fi

mkdir -p "$destination_dir"
tar -xzf "$output_file" -C "$destination_dir"

if [ $? -eq 0 ]; then
  echo "Archive extracted successfully in '$destination_dir'."
  rm -rf "$clang_gz"
else
  echo "The extraction of the zip failed!"
fi

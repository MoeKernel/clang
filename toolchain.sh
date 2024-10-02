#!/bin/bash

# -----------------------------
# script created by
#     Akari Azusagawa © 2024
# ----------------------------- 

user="Neutron-Toolchains" # GitHub user.
repo="clang-build-catalogue"
version="11032023"
clang_tar_zst="neutron-clang-$version.tar.zst"
url="https://github.com/$user/$repo/releases/download/$version/$clang_tar_zst"

output_file="$clang_tar_zst"
destination_dir="$HOME/tc/clang-17.0.0"

if [ -d "$destination_dir" ]; then
  echo "The directory '$destination_dir' already exists. Exiting script."
  exit 0
fi

if ! command -v curl &>/dev/null; then
  echo "The command 'curl' is not installed. Installing it now..."
  sudo apt update -y 
  sudo apt install curl -y
  if [ $? -ne 0 ]; then
    echo "Failed to install 'curl'. Exiting."
    exit 1
  fi
fi

if ! command -v zstd &>/dev/null; then
  echo "The command 'zstd' is not installed. Installing it now..."
  sudo apt update -y 
  sudo apt install zstd -y
  if [ $? -ne 0 ]; then
    echo "Failed to install 'zstd'. Exiting."
    exit 1
  fi
fi

echo "Downloading $url..."
curl -LO "$url"

if [ $? -ne 0 ]; then
  echo "The download of the archive has failed."
  exit 1
fi

mkdir -p "$destination_dir"

echo "Extracting $output_file to $destination_dir..."
tar --use-compress-program=zstd -xf "$output_file" -C "$destination_dir"

if [ $? -eq 0 ]; then
  echo "Archive extracted successfully in '$destination_dir'."
  rm -f "$output_file"
else
  echo "The extraction of the archive failed!"
  exit 1
fi

#!/bin/bash
#
# -----------------------------
# script created by
#     Akari Azusagawa © 2024
#
# > download clang lazily.
# -----------------------------

user="ZyCromerZ" # GitHub user.

usage() {
  echo "Usage: $0 --version <clang_version> --date <release_date>"
  echo "Example: $0 --version 18.0.0 --date 20240124"
  exit 1
}

if [[ $# -ne 4 ]]; then
  usage
fi

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --version) version_no_git="$2"; shift ;;
    --date) date_="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; usage ;;
  esac
  shift
done

version_clang="${version_no_git}git"
version="$version_clang-$date_-release"
clang_gz="Clang-${version_clang}-$date_.tar.gz"
url="https://github.com/$user/Clang/releases/download/$version/$clang_gz"
output_file="$clang_gz"
destination_dir="$HOME/tc/clang-${version_no_git}"

if [ -d "$destination_dir" ]; then
  echo "The directory '$destination_dir' already exists. Exiting script."
  exit 0
fi

if ! command -v curl &>/dev/null; then
  echo "The command 'curl' is not installed. Please install it to continue."
  sudo apt update -y
  sudo apt install curl -y
  if [ $? -ne 0 ]; then
    echo "Failed to install 'curl'. Exiting."
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
tar -xzf "$output_file" -C "$destination_dir"

if [ $? -eq 0 ]; then
  echo "Archive extracted successfully in '$destination_dir'."
  rm -rf "$clang_gz"
else
  echo "The extraction of the archive failed!"
  exit 1
fi

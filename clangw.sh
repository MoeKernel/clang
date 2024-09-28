#!/bin/bash
#
# -----------------------------
# script created by
#     Akari Azusagawa © 2024
# -----------------------------

user="ZyCromerZ"
token="your_token_github"

usage() {
  echo "Usage: $0 --version <clang_version>"
  echo "E.g (Example): $0 --version 18.0.0"
  exit 1
}

if [[ $# -ne 2 ]]; then
  usage
fi

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --version) version_no_git="$2"; shift ;;
    *) echo "Unknown parameter passed: $1"; usage ;;
  esac
  shift
done

get_latest_release() {
  page=1
  per_page=30

  while true; do
    releases=$(curl -s -H "Authorization: token $token" \
      "https://api.github.com/repos/$user/Clang/releases?per_page=$per_page&page=$page")

    if [[ -z "$releases" || "$releases" == "[]" ]]; then
      break
    fi

    version=$(echo "$releases" | grep -oP '"tag_name": "\K(.*?)(?=")' | grep "^${version_no_git}git" | head -n 1)

    if [[ ! -z "$version" ]]; then
      echo "$version"
      return 0
    fi

    ((page++))
  done

  echo ""
  return 1
}

latest_version=$(get_latest_release)

if [ -z "$latest_version" ]; then
  echo "The specified version $version_no_git was not found."
  exit 1
fi

version="${latest_version/-release/}"
echo $version

clang_gz="Clang-$version.tar.gz"
echo $clang_gz

url="https://github.com/$user/Clang/releases/download/$version-release/$clang_gz"
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
echo "URL: $url"
curl -LO "$url"

if [ ! -s "$output_file" ]; then
  echo "Download failed or file is empty!"
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

#!/usr/bin/env bash
currentDir=`pwd`
shell="/bin/bash"
user=`whoami`

function show_usage {
  echo "must run with super-user privileges."
  echo -e "\nUsage: bootstrap.sh [-h] [-u user_name]"
}

function addUserPrompt {
  echo -n "please input home directory: "
  read homeDir
}

function setup_home_dir {
  homeDirs=(bin utility lab personal resource)
  for i in "${homeDirs[@]}"; do
    if [ -d "$homeDir/${i}" ]; then
      continue
    else
      mkdir $homeDir/${i}
    fi
  done
  # directory privilege
  chown -R $user:$user $homeDir
}

function setup_sudoers {
    echo "$user ALL=(ALL:ALL) ALL" >> /etc/sudoers
}

# parameter parsing
if [ $# -lt 1 ]; then
  show_usage
  exit 1
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help)
      show_usage
      shift
      ;;
    -u|--user)
      shift
      if [[ "$#" -eq 0 || "$1" =~ ^- ]]; then
        show_usage
        exit 1
      fi
      #use adduser not useradd to add user
      user=$1
      homeDir=/home/$1
      adduser $1 --home $homeDir --shell $shell
      # if adduser fails cannot do setup
      if [ $? -gt 0 ]; then
        exit 1
      fi
      setup_home_dir
      setup_sudoers
      shift
      ;;
  esac
done

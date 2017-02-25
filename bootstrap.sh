#!/usr/bin/env bash
currentUsr=`whoami`
currentDir=`pwd`
shell="/bin/bash"
# parameter parsing
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
    if [ -d "$currentDir/${i}" ]; then
      continue
    else
      mkdir $currentDir/${i}
    fi
  done
}

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
      homeDir=/home/$1
      addUserPrompt
      adduser $1 --home $homeDir --shell $shell
      setup_home_dir
      shift
      ;;
  esac
done

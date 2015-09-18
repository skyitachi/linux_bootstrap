#!/usr/bin/env bash
currentUsr=`whoami`
currentDir=`pwd`
shell="/bin/bash"
function addUserPrompt {
  echo -n "please input home directory: "
  read homeDir
}
function loadPreset {
  if [ -f "conf.sh" ]; then
    source conf.sh
  fi
}
loadPreset
#use adduser not useradd to add user
while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help)
      echo "0.0.1"
      shift
      ;;
    -u|--user)
      shift
      if [[ "$#" -eq 0 || "$1" =~ ^- ]]; then
        echo "please provide user"
        exit 1
      fi
      homeDir=/home/$1
      addUserPrompt
      adduser $1 --home $homeDir --shell $shell
      shift
      ;;
  esac
done

echo $user
if [ -n $user ]; then
  echo "add $user"
fi
#if [ $currentUsr != "root" ]; then
#  echo "please run with root"
#  exit 1
#fi
homeDirs=(bin utility lab personal resource)
for i in "${homeDirs[@]}"; do
  if [ -d "$currentDir/${i}" ]; then
    continue
  else
    mkdir $currentDir/${i}
  fi
done
echo $currentUsr


#!/usr/bin/env bash

while test $# -gt 0; do
    case "$1" in
        --dev)
            APP_ENV="development"
            shift
            ;;

        *)
            break
            ;;
    esac
done

PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ansible|grep "install ok installed")
echo Checking for Ansible: $PKG_OK

. /etc/lsb-release

if [ "" == "$PKG_OK" ]; then
    sudo apt-get update
    sudo apt-get install -q -y software-properties-common
    sudo add-apt-repository -y ppa:ansible/ansible

# if [ $DISTRIB_RELEASE = "14.04" ]; then
#         sudo add-apt-repository -y ppa:fkrull/deadsnakes-python2.7
#    fi

    sudo apt-get update
    sudo apt-get install -q -y python2.7 python-pip python-mysqldb ansible
fi

APP_ENV="${APP_ENV:-production}"

echo "Installing AzuraCast (Environment: $APP_ENV)"
ansible-playbook util/ansible/deploy.yml --inventory=util/ansible/hosts --extra-vars "app_env=$APP_ENV"
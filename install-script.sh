#!/usr/bin/env bash


set -e -u -o pipefail
path=/var/lib/replicated/snapshots/
set -x
set fileformat=unix


###Installing replicated


FILE=/var/lib/replicated/snapshots/files/db.dump
if [ -f "$FILE" ]; then
  [ -f /etc/replicated.conf ] || cp /vagrant/replicated.conf /etc/replicated.conf
  curl -o install.sh https://install.terraform.io/ptfe/stable
  bash ./install.sh \
    no-proxy \
    private-address=192.168.56.33 \
    public-address=192.168.56.33

  sleep 100
  replicatedctl snapshot ls --store local --path /var/lib/replicated/snapshots -o json > /tmp/snapshots.json
  id=$(jq -r 'sort_by(.finished) | .[-1].id // ""' /tmp/snapshots.json)

  echo "Restoring snapshot: $id"
  replicatedctl snapshot restore --store local --path /var/lib/replicated/snapshots --dismiss-preflight-checks "$id"
  sleep 5
  service replicated restart
  service replicated-ui restart
  service replicated-operator restart

  sleep 40

  replicated app $(replicated apps list | grep "Terraform Enterprise" | awk {'print $1'}) start
else 
    echo "No snapshots found"
    echo "Installing Terraform Enterprise"
    [ -f /etc/replicated.conf ] || cp /vagrant/replicated.conf /etc/replicated.conf
    curl -o install.sh https://install.terraform.io/ptfe/stable
    bash ./install.sh \
        no-proxy \
        private-address=192.168.56.33 \
        public-address=192.168.56.33
fi

exit 0
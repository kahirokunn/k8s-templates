#!/usr/bin/env bash

JSON=$(terraform -chdir=./terraform show -json)

function create () {
  echo $JSON | jq --arg subnet_type $1 '[.. | select(.type? == "aws_subnet" and .name? == $subnet_type) | { az: .values.availability_zone, id: .values.id }]'
}

create public > public_subnets.json
create private > private_subnets.json

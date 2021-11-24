#!/usr/bin/env bash

JSON=$(terraform -chdir=./terraform show -json)

function create () {
  echo $JSON | jq --arg subnet_type $1 '[.. | select(.type? == "aws_subnet" and .name? == $subnet_type) | { az: .values.availability_zone, id: .values.id }]'
}

PUBLIC=$(create public)
PRIVATE=$(create private)
echo "{\"public\": ${PUBLIC}}" > public_subnets_tmp.json
echo "{\"private\": ${PRIVATE}}" > private_subnets_tmp.json
jq -s add public_subnets_tmp.json private_subnets_tmp.json > vpc_subnets.json
rm public_subnets_tmp.json private_subnets_tmp.json

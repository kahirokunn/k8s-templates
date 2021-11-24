#! /usr/bin/env node

const subnetJson = require('./vpc_subnets.json');

const cmp = (a, b) => a.az.localeCompare(b.az)
Object.values(subnetJson).forEach(subnets => subnets.sort(cmp));

function getEksNum() {
  const publicSubnets = subnetJson["public"];
  const first = publicSubnets[0].az;
  let i = 0;
  for (const subnet of publicSubnets) {
    if (first !== subnet.az) {
      return i;
    }
    i++;
  }
  throw Error(`impossible i: ${i}`)
}

let eksNum = getEksNum();
const eksSubnets = [];

for (let i = 0; i < eksNum; i++) {
  eksSubnets[i] = {
    public: [],
    private: [],
  };

  for (const [type, subnets] of Object.entries(subnetJson)) {
    for (let j = i; j < subnets.length; j+=eksNum) {
      eksSubnets[i][type].push(subnetJson[type][j]);
    }
  }
}

console.log(JSON.stringify(eksSubnets))

local subnets = import "./eks_subnets.json";
local publicSubnets = subnets[0].public;
local privateSubnets = subnets[0].private;

local config = import "../config.json";

local commonTags = {
  "Hello": "k8s_world",
};

local getClusterName(i) = config.base_cluster_name + "-" + i;

local nodegroupTags(i) = {
  "nodegroup-role": "worker",
  "k8s.io/cluster-autoscaler/enabled": "true",
  ["k8s.io/cluster-autoscaler/" + getClusterName(i)]: "owned",
} + commonTags;

local desiredCapacity = (std.length(privateSubnets) + std.length(publicSubnets)) * 2;

local nodegroup(i, az, instanceType, desiredCapacity, type) = {
  name: 'managed-' + std.strReplace(instanceType, '.', '-') + '-' + az + '-' + type,
  instanceType: instanceType,
  availabilityZones: [az],
  privateNetworking: true,
  minSize: 0,
  maxSize: 10,
  desiredCapacity: desiredCapacity,
  // GB
  volumeSize: 100,
  labels: {
    role: "worker"
  },
  tags: nodegroupTags(i) + {
    type: type
  },
};

local generateClusterConfig(i, publicSubnets, privateSubnets) = {
    apiVersion: 'eksctl.io/v1alpha5',
    kind: 'ClusterConfig',
    metadata: {
      name: getClusterName(i),
      region: config.region,
      version: '1.21',
    },
    iam: {
      withOIDC: true,
      serviceAccounts: [
        {
          metadata: {
            name: "cluster-autoscaler",
            namespace: "kube-system",
          },
          wellKnownPolicies: {
            autoScaler: true,
          },
          tags: commonTags,
        },
        {
          metadata: {
            name: "aws-load-balancer-controller",
            namespace: "kube-system",
          },
          wellKnownPolicies: {
            awsLoadBalancerController: true,
          },
          tags: commonTags,
        },
        {
          metadata: {
            name: 'ebs-csi-controller-sa',
            namespace: 'kube-system',
          },
          wellKnownPolicies: {
            ebsCSIController: true,
          },
          tags: commonTags,
        }
      ],
    },
    vpc: {
      subnets: {
        private: {
          [s.az]: {
            id: s.id
          },
          for s in privateSubnets
        },
        public: {
          [s.az]: {
            id: s.id
          },
          for s in publicSubnets
        },
      },
    },
    nodeGroups: [
      nodegroup(i, s.az, 't3.medium', 2, 'private')
      for s in privateSubnets
    ] + [
      // 必要になったらauto scalerに作ってもらうので、最初は0で作成します
      nodegroup(i, s.az, 't3.medium', 0, 'public')
      for s in publicSubnets
    ],
    addons: [{
      name: 'vpc-cni',
      version: 'latest',
      attachPolicyARNs: ['arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy'],
      attachPolicy: {
        Statement: [
          {
            Effect: 'Allow',
            Action: [
              'ec2:AssignPrivateIpAddresses',
              'ec2:AttachNetworkInterface',
              'ec2:CreateNetworkInterface',
              'ec2:DeleteNetworkInterface',
              'ec2:DescribeInstances',
              'ec2:DescribeTags',
              'ec2:DescribeNetworkInterfaces',
              'ec2:DescribeInstanceTypes',
              'ec2:DetachNetworkInterface',
              'ec2:ModifyNetworkInterfaceAttribute',
              'ec2:UnassignPrivateIpAddresses',
            ],
            Resource: '*'
          },
        ],
      },
      tags: commonTags,
    }]
  };

if std.length(privateSubnets) == 0 || std.length(publicSubnets) == 0 then
  error 'required private subnets and public subnets.'
else
  std.mapWithIndex(function(i, subnets) std.manifestYamlDoc(generateClusterConfig(i, subnets.public, subnets.private)), subnets)[config.current_index]

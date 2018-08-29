#!/bin/bash

# This script creates a test-cluster in a separate VPC.
export KOPS_NAME="YOUR CLUSTER NAME"
export KOPS_STATE_STORE="YOUR S3 BUCKET"
export PRIVATE_HOSTED_ZONE_ID="PRIVATE HOSTED ZONE ID"
export PUBLIC_HOSTED_ZONE_ID="PUBLIC HOSTED ZONE ID"
export K8S_API_ADDRESS="api.k8s.<YOUR DOMAIN>"
export KUBECONFIG=~/.kube/env/test

# Deploy cluster
kops create cluster \
  --name ${KOPS_NAME} \
  --node-count 3 \
  --zones eu-west-1a,eu-west-1b,eu-west-1c \
  --master-zones eu-west-1a,eu-west-1b,eu-west-1c \
  --dns-zone=${PRIVATE_HOSTED_ZONE_ID} \
  --dns private \
  --node-size t2.medium \
  --master-size t2.small \
  --topology private \
  --networking weave \
  --bastion \
  --yes


# Configure Route53 and add the dns entry in the public zone to be able to access it.
DNS=$(aws elb describe-load-balancers --region eu-west-1 | jq '.LoadBalancerDescriptions[]  | select(.DNSName | startswith("api-k8s-<YOUR DOMAIN>")) | .DNSName')
echo "${DNS//\"}"

# Create the route53 entry to access the kubernetes api
aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch "
  {
      \"Comment\": \"Update DNS record to the new Loadbalancer Endpoint\",
      \"Changes\": [
          {
              \"Action\": \"UPSERT\",
              \"ResourceRecordSet\": {
                  \"Type\": \"CNAME\",
                  \"TTL\": 300,
                  \"ResourceRecords\": [
                    {
                        \"Value\": \"${DNS//\"}\"
                    }
                    ],
                  \"Name\": \"${K8S_API_ADDRESS}\"
              }
          }
      ]
  }
  "
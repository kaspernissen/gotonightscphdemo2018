#!/bin/bash
PUBLIC_HOSTED_ZONE_ID="Z1SPJ1X6C8O8RZ"

ELB_DNS="dualstack.$(kubectl get svc nginx-ingress-controller -ojson | jq -r '.status.loadBalancer.ingress[0].hostname')"
ELB_HOSTED_ZONE_ID="$(aws elb describe-load-balancers --region eu-west-1 | jq -r '.LoadBalancerDescriptions[0].CanonicalHostedZoneNameID')"

echo "DNS Name for ELB: ${ELB_DNS}"

echo "Setup api.<YOUR DOMAIN>"
aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch "
{
     \"Comment\": \"Creating Alias resource record sets in Route 53\",
     \"Changes\": [{
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                            \"Name\": \"api.<YOUR DOMAIN>.\",
                            \"Type\": \"A\",
                            \"AliasTarget\":{
                                    \"HostedZoneId\": \""${ELB_HOSTED_ZONE_ID}"\",
                                    \"DNSName\": \"${ELB_DNS}\",
                                    \"EvaluateTargetHealth\": false
                              }}
                          }]
}
"

echo "Setup rabbitmq.<YOUR DOMAIN>"
aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch "
{
     \"Comment\": \"Creating Alias resource record sets in Route 53\",
     \"Changes\": [{
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                            \"Name\": \"rabbitmq.<YOUR DOMAIN>.\",
                            \"Type\": \"A\",
                            \"AliasTarget\":{
                                    \"HostedZoneId\": \""${ELB_HOSTED_ZONE_ID}"\",
                                    \"DNSName\": \"${ELB_DNS}\",
                                    \"EvaluateTargetHealth\": false
                              }}
                          }]
}
"

echo "Setup prometheus.<YOUR DOMAIN>"
aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch "
{
     \"Comment\": \"Creating Alias resource record sets in Route 53\",
     \"Changes\": [{
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                            \"Name\": \"prometheus.<YOUR DOMAIN>.\",
                            \"Type\": \"A\",
                            \"AliasTarget\":{
                                    \"HostedZoneId\": \""${ELB_HOSTED_ZONE_ID}"\",
                                    \"DNSName\": \"${ELB_DNS}\",
                                    \"EvaluateTargetHealth\": false
                              }}
                          }]
}
"

echo "Setup humio.<YOUR DOMAIN>"
aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch "
{
     \"Comment\": \"Creating Alias resource record sets in Route 53\",
     \"Changes\": [{
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                            \"Name\": \"humio.<YOUR DOMAIN>.\",
                            \"Type\": \"A\",
                            \"AliasTarget\":{
                                    \"HostedZoneId\": \""${ELB_HOSTED_ZONE_ID}"\",
                                    \"DNSName\": \"${ELB_DNS}\",
                                    \"EvaluateTargetHealth\": false
                              }}
                          }]
}
"

echo "Setup grafana.<YOUR DOMAIN>"
aws route53 change-resource-record-sets --hosted-zone-id $PUBLIC_HOSTED_ZONE_ID --change-batch "
{
     \"Comment\": \"Creating Alias resource record sets in Route 53\",
     \"Changes\": [{
                \"Action\": \"CREATE\",
                \"ResourceRecordSet\": {
                            \"Name\": \"grafana.<YOUR DOMAIN>.\",
                            \"Type\": \"A\",
                            \"AliasTarget\":{
                                    \"HostedZoneId\": \""${ELB_HOSTED_ZONE_ID}"\",
                                    \"DNSName\": \"${ELB_DNS}\",
                                    \"EvaluateTargetHealth\": false
                              }}
                          }]
}
"
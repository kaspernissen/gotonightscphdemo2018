#!/bin/bash

helm install stable/nginx-ingress --name=nginx-ingress

kubectl apply -f ingress/
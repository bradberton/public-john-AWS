#!/bin/sh
git add -A;
git commit -m "commit complete";
git push origin main;
terraform plan;
terraform validate;

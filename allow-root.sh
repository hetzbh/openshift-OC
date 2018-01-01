#!/bin/bash

oc login -u system:admin
oc adm policy add-scc-to-group anyuid system:authenticated

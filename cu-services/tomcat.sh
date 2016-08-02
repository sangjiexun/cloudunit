#!/usr/bin/env bash

docker build --rm --no-cache -t cloudunit/base-12.04 images/base-12.04
docker build --rm -t cloudunit/tomcat-6 images/servers/appconf/tomcat-6
docker build --rm -t cloudunit/tomcat-7 images/servers/appconf/tomcat-7
docker build --rm -t cloudunit/tomcat-8 images/servers/appconf/tomcat-8
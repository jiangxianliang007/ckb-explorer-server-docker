#!/bin/bash
WORK_DIR=$PWD
set -e

setup_app(){
  cd $WORK_DIR
  unzip ./ckb-explorer-server.zip -d /opt/
  mv -v /opt/ckb-explorer-master /opt/ckb-explorer-server

  cd /opt/ckb-explorer-server
  #./bin/setup
  #bundle check
  bundle install

}

setup_app

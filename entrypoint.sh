#!/bin/bash
set -e

cp /config/.env.local /opt/ckb-explorer-server/
cp /config/master.key /opt/ckb-explorer-server/config/master.key
chmod 400 /opt/ckb-explorer-server/config/master.key

cd /opt/ckb-explorer-server

init() {
RAILS_ENV=production ./bin/rails db:prepare
#  ./bin/rails db:prepare

echo "\n== Removing old logs and tempfiles =="
./bin/rails log:clear tmp:clear

echo "\n== Restarting application server =="
./bin/rails restart
}
ckb_block_node_processor() {
   /opt/ckb-explorer-server/bin/rails runner lib/ckb_block_node_processor.rb -e production
}
ckb_statistic_info_chart_data_updater() {
   /opt/ckb-explorer-server/bin/rails runner lib/ckb_statistic_info_chart_data_updater.rb -e production
}

run_puma() {
   PIDFILE=/run/puma.pid puma -b tcp://0.0.0.0:8080  -e production
#curl 'localhost:30001/api/v1/blocks' -H 'Accept: application/vnd.api+json' -H 'Content-Type: application/vnd.api+json'
}

case $1 in
   init)
      init
      ;;
   puma)
      run_puma
      ;;
   block_node_processor)
      ckb_block_node_processor
      ;;
   statistic_info_chart_data_updater)
      ckb_block_node_processor
      ;;
   *)
      run_puma
      ;;
esac

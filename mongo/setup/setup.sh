#!/bin/sh
echo "Waiting for Mongo..."
sleep 40
echo "Mongo started."
mongo --host mongo500:27017 --version
mongo --host mongo506:27017 --version
mongo --host mongo508:27017 --version
mongo --host mongo530:27017 --version
mongo --host mongo600:27017 --version
echo "Configuring..."
mongo --host mongo500:27017 --eval 'rs.initiate()'
mongo --host mongo506:27017 --eval 'rs.initiate()'
mongo --host mongo508:27017 --eval 'rs.initiate()'
mongo --host mongo530:27017 --eval 'rs.initiate()'
mongo --host mongo600:27017 --eval 'rs.initiate()'
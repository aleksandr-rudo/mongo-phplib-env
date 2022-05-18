#!/bin/sh
set -o errexit  # Exit the script with error if any of the commands fail

git clone https://github.com/mongodb-labs/drivers-evergreen-tools.git
cp ./drivers-evergreen-tools/.evergreen/download-mongodb.sh ./download-mongodb.sh
rm -r ./drivers-evergreen-tools

download_custom_and_extract ()
{
   MONGODB_DOWNLOAD_URL=$1
   EXTRACT=$2

   cd $DRIVERS_TOOLS
   curl --retry 8 -sS $MONGODB_DOWNLOAD_URL --max-time 300 --output mongodb-binaries.tgz
   $EXTRACT mongodb-binaries.tgz

   rm -f mongodb-binaries.tgz
   mv mongodb* mongodb

   find . -name vcredist_x64.exe -exec {} /install /quiet \;
   ./mongodb/bin/mongod --version
   cd -
}

# Supported environment variables:
#   AUTH                   Set to "auth" to enable authentication. Defaults to "noauth"
#   SSL                    Set to "yes" to enable SSL. Defaults to "nossl"
#   TOPOLOGY               Set to "server", "replica_set", or "sharded_cluster". Defaults to "server" (i.e. standalone).
#   LOAD_BALANCER          Set to a non-empty string to enable load balancer. Only supported for sharded clusters.
#   STORAGE_ENGINE         Set to a non-empty string to use the <topology>/<storage_engine>.json configuration (e.g. STORAGE_ENGINE=inmemory).
#   REQUIRE_API_VERSION    Set to a non-empty string to set the requireApiVersion parameter. Currently only supported for standalone servers.
#   DISABLE_TEST_COMMANDS  Set to a non-empty string to use the <topology>/disableTestCommands.json configuration (e.g. DISABLE_TEST_COMMANDS=1).
#   MONGODB_VERSION        Set to a MongoDB version to use for download-mongodb.sh. Defaults to "latest".
#   MONGODB_DOWNLOAD_URL   Set to a MongoDB download URL to use for download-mongodb.sh.
#   ORCHESTRATION_FILE     Set to a non-empty string to use the <topology>/<orchestration_file>.json configuration.

AUTH=${AUTH:-noauth}
SSL=${SSL:-nossl}
TOPOLOGY=${TOPOLOGY:-server}
LOAD_BALANCER=${LOAD_BALANCER}
STORAGE_ENGINE=${STORAGE_ENGINE}
REQUIRE_API_VERSION=${REQUIRE_API_VERSION}
DISABLE_TEST_COMMANDS=${DISABLE_TEST_COMMANDS}
MONGODB_VERSION=${MONGODB_VERSION:-latest}
MONGODB_DOWNLOAD_URL=${MONGODB_DOWNLOAD_URL}
ORCHESTRATION_FILE=${ORCHESTRATION_FILE}


DL_START=$(date +%s)
DIR=$(dirname $0)
# Functions to fetch MongoDB binaries
. $DIR/download-mongodb.sh

get_distro
if [ -z "$MONGODB_DOWNLOAD_URL" ]; then
    get_mongodb_download_url_for "$DISTRO" "$MONGODB_VERSION"
else
  # Even though we have the MONGODB_DOWNLOAD_URL, we still call this to get the proper EXTRACT variable
  get_mongodb_download_url_for "$DISTRO"
fi
download_custom_and_extract "$MONGODB_DOWNLOAD_URL" "$EXTRACT"

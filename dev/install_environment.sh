#!/bin/sh

LIBRARY_REPO=${LIBRARY_REPO:-}
DRIVER_REPO=${DRIVER_REPO:-}
SPECIFICATIONS_REPO=${SPECIFICATIONS_REPO:-}
COMPASS_REPO=${COMPASS_REPO:-}

# Functions to fetch MongoDB binaries
. functions.sh

install_driver "$DRIVER_REPO"
build_latest_driver
install_library "$LIBRARY_REPO"
install_specifications "$SPECIFICATIONS_REPO"
install_compass "$COMPASS_REPO"

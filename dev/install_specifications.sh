#!/bin/sh

LIBRARY_REPO=${LIBRARY_REPO:-}
DRIVER_REPO=${DRIVER_REPO:-}
SPECIFICATIONS_REPO=${SPECIFICATIONS_REPO:-}
COMPASS_REPO=${COMPASS_REPO:-}

# Functions to fetch MongoDB binaries
. functions.sh

install_specifications "$SPECIFICATIONS_REPO"

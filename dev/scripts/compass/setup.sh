#!/bin/sh
npm run bootstrap
cd packages/bson-transpilers
npm run compile && npm run test
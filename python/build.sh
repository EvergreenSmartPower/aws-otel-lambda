#!/bin/bash

# Build collector

pushd ../opentelemetry-lambda/collector || exit
make package
popd || exit

# Build sdk layer

cd ../opentelemetry-lambda/python/src || exit
./build.sh

pushd ../sample-apps || exit
./build.sh
popd || exit

# Go to build folder
cd ./build || exit

# Add AWS X-Ray dependencies
pip install opentelemetry-sdk-extension-aws -t python/

# Combine the layers
unzip -qo layer.zip
rm layer.zip
unzip -qo ../../../collector/build/collector-extension.zip

# Use our AWS scripts instead which extend and call OTel Lambda scripts
mv otel-instrument otel-instrument-upstream-lambda
cp ../../../../python/scripts/otel-instrument .

# Zip all the files in `opentelemetry-lambda/python/src/build` together for the
# layer
zip -qr layer.zip *

#!/usr/bin/env bash

swift build --disable-sandbox
rm /usr/local/bin/retina
cp .build/debug/retina /usr/local/bin/retina

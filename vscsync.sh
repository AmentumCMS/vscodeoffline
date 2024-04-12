#!/bin/bash
docker run -it --rm \
  -v ./artifacts:/artifacts:Z \
  -e SYNCARGS="--check-specified-extensions --update-extensions --update-binaries" \
  vscsync

DATE=`date '+%Y%m%d-%H%M'`

tar -czvf vscsync-extensions_$DATE.tgz artifacts/extensions
tar -czvf vscsync-installers_$DATE.tgz artifacts/installers
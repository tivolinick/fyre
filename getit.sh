#!/bin/sh
  #fyreAPIkey=htkYW7w0Ped3yozzvtFM3GSUN9t6nvfFZzEVGbWwp
  #curl -X GET -k -u nick.freer:$fyreAPIKey  $1 2> /dev/null

. ~/.fyre/creds
  curl -X GET -k -u ${fyreAPIuser}:${fyreAPIkey}  $1 2> /dev/null

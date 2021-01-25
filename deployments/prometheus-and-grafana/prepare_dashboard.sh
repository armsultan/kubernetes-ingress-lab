# !/bin/bash
# 
# Usage: 
# 1. Copy the JSON from Grafana -> Export as JSON -> Clipboard -> Save as json
# 2. ./prepare_dashboard.sh saved_json.json
# - This will update saved_json.json
#
# This script is based on one of @aranair:
# https://gist.github.com/aranair/bec788df5a9a292f42e088e481b856c6
# and @tretos53
# https://github.com/tretos53/notes/blob/master/Grafana/Readme.MD

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "$#" -ne 1 ]; then
  echo "Usage: ./prepare_dashboard.sh <name_of_dashboard>"
  exit
fi

# Prepare JSON for Grafana Watcher
newContent=`cat "$DIR/$1" | \
  jq 'select(has("dashboard") | not) | .id = null | del(.__requires) | del(.uid) | { dashboard: . , inputs: .__inputs, overwrite: true  }' | \
  jq '.inputs[0].value=.inputs[0].pluginId'`

# If above commands find "dashboard" at the object root it will avoid doing anything
if [ "$newContent" != "" ]
then
  echo "$newContent" > "$DIR/$1"
  echo "The file is ready to be imported in Grafana"
else
  echo "This file has already been modified"
fi
#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../docker"; source .env; mkdir -p sonar-plugins
curl -fsSL -o "sonar-plugins/sonar-bsl-plugin-community-${SONAR_BSL_PLUGIN_VERSION}.jar" \
 "https://github.com/1c-syntax/sonar-bsl-plugin-community/releases/download/v${SONAR_BSL_PLUGIN_VERSION}/sonar-communitybsl-plugin-${SONAR_BSL_PLUGIN_VERSION}.jar"

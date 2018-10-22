#!/bin/bash

set -eu

# Start mysql.
service mysql start

# Configure buildkite.
if [ -z "${BUILDKITE_AGENT_TOKEN}" ]
then
  echo 'Please provide the buildkite agent token (--env BUILDKITE_AGENT_TOKEN=xxx)!'
  exit 1
fi
sed -i "s/xxx/${BUILDKITE_AGENT_TOKEN}/g" /etc/buildkite-agent/buildkite-agent.cfg
sed -i "/tags=\"key1=val2,key2=val2\"/s/.*/tags=\"${BUILDKITE_AGENT_TAGS}\"/" /etc/buildkite-agent/buildkite-agent.cfg;

# Start Buildkite.
sudo -u buildkite-agent -H bash -c '/usr/bin/buildkite-agent start'

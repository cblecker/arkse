#!/usr/bin/env bash
if docker images -q ${1}
  echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
  docker push "${1}"
else
  echo "ERROR: Unable to push -- ${1} doesn't exist." >&2
  exit 1
fi

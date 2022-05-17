#!/usr/bin/env bash

declare -a TAGS=("basic" "red" "yellow" "green")

for TAG in "${TAGS[@]}"
do
  echo ""
  echo "------------------"
	echo "--> building version $TAG"
	echo "------------------"

  echo ""
	echo "--> goldie main"
  if ! docker build -f src/main/docker/Dockerfile ./src/main --build-arg VERSION="${TAG}" --tag "${REPOSITORY}"/goldie-main:"${TAG}"; then
    echo "goldie main build failed with rc $?"
    exit 1
  fi

	echo "--> goldie body"
  if ! docker build -f src/body/docker/Dockerfile ./src/body --build-arg VERSION="${TAG}" --tag "${REPOSITORY}"/goldie-body:"${TAG}"; then
    echo "goldie main build failed with rc $?"
    exit 1
  fi


  if [[ ! -z ${PUSH} ]]; then
    echo ""
    echo "--> pushing images for tag $TAG"
    (docker push "${REPOSITORY}"/goldie-main:"${TAG}" && \
    docker push "${REPOSITORY}"/goldie-body:"${TAG}") || exit 1
  fi

done

#!/bin/bash




docker build -f src/docker/dockerfile -t litterbox-server .

docker tag litterbox-server gcr.io/katzenklo-176615/litterbox-server

gcloud docker -- push gcr.io/katzenklo-176615/litterbox-server

#!/bin/bash

cat /dev/urandom  | tr -dc a-f0-9 | head -c12 | sed 's/\(..\)\(..\)\(..\)\(..\)\(..\)\(..\)/\1:\2:\3:\4:\5:\6/'

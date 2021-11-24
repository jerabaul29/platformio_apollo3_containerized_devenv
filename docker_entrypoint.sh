#!/bin/bash
set -e

if [ $# -eq 0 ]
  then
    code -n to_open
  else
    exec "$@"
fi
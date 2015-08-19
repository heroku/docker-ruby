#!/bin/bash

for SCRIPT in /app/.profile.d/*;
  do source $SCRIPT;
done

exec "$@"

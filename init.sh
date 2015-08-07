#!/bin/bash

for SCRIPT in /app/.profile.d/*;
  do source $SCRIPT;
done

rm -rf /app/user/.bundle
cp -rf /app/heroku/ruby/.bundle /app/user/

exec $*

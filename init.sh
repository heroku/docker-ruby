#!/bin/bash

mkdir -p /app/heroku/.profile.d/

ruby_version=$(ruby-util detect-ruby /app/user/Gemfile)
if ls /app/heroku/ruby/$ruby_version 1> /dev/null 2>&1; then
	echo "$ruby_version already installed"
	cp /app/heroku/.profile.d/ruby.sh /app/.profile.d/
else
	ruby-util install-ruby /app/user/Gemfile /app/heroku/ruby /app/.profile.d/ruby.sh
	cp /app/.profile.d/ruby.sh /app/heroku/.profile.d/
fi
ruby-util rails-env /app/.profile.d/ruby.sh
if bundler_version=$(ruby-util detect-gem /app/heroku/.profile.d/ruby.sh bundler) && [ -z $bundler_version ]; then
	ruby-util install-bundler 1.13.7 /app/heroku/ruby/.bundle/config /app/.profile.d/ruby.sh
	cp /app/.profile.d/ruby.sh /app/heroku/.profile.d/
else
	echo "bundler $bundler_version already installed"
	cp /app/heroku/.profile.d/ruby.sh /app/.profile.d/
fi
ruby-util bundle-install /app/heroku/ruby/bundle /app/.profile.d/ruby.sh
if ls /app/heroku/ruby/node-* 1> /dev/null 2>&1; then
	echo "node already installed"
	cp /app/heroku/.profile.d/ruby.sh /app/.profile.d/
else
	ruby-util install-node 0.12.7 /app/heroku/ruby/ /app/.profile.d/ruby.sh
	cp /app/.profile.d/ruby.sh /app/heroku/.profile.d/
fi

for SCRIPT in /app/.profile.d/*;
  do source $SCRIPT;
done

exec "$@"

FROM heroku/cedar:14
MAINTAINER Terence Lee <terence@heroku.com>

ENV RUBY_VERSION 2.3.0
ENV NODE_VERSION 0.12.7
ENV BUNDLER_VERSION 1.9.10

RUN mkdir -p /app/user
WORKDIR /app/user

ENV GEM_PATH /app/heroku/ruby/bundle/ruby/$RUBY_VERSION
ENV GEM_HOME /app/heroku/ruby/bundle/ruby/$RUBY_VERSION
RUN mkdir -p /app/heroku/ruby/bundle/ruby/$RUBY_VERSION

# Install Ruby
RUN mkdir -p /app/heroku/ruby/ruby-$RUBY_VERSION
RUN curl -s --retry 3 -L https://heroku-buildpack-ruby.s3.amazonaws.com/cedar-14/ruby-$RUBY_VERSION.tgz | tar xz -C /app/heroku/ruby/ruby-$RUBY_VERSION
ENV PATH /app/heroku/ruby/ruby-$RUBY_VERSION/bin:$PATH

# Install Node
RUN curl -s --retry 3 -L http://s3pository.heroku.com/node/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz | tar xz -C /app/heroku/ruby/
RUN mv /app/heroku/ruby/node-v$NODE_VERSION-linux-x64 /app/heroku/ruby/node-$NODE_VERSION
ENV PATH /app/heroku/ruby/node-$NODE_VERSION/bin:$PATH

# Install Bundler
RUN gem install bundler -v $BUNDLER_VERSION --no-ri --no-rdoc
ENV PATH /app/user/bin:/app/heroku/ruby/bundle/ruby/$RUBY_VERSION/bin:$PATH
ENV BUNDLE_APP_CONFIG /app/heroku/ruby/.bundle/config

# Run bundler to cache dependencies
ONBUILD COPY ["Gemfile", "Gemfile.lock", "/app/user/"]
ONBUILD RUN bundle install --path /app/heroku/ruby/bundle --jobs 4
ONBUILD ADD . /app/user

# How to conditionally `rake assets:precompile`?
ONBUILD ENV RAILS_ENV production
ONBUILD ENV SECRET_KEY_BASE $(openssl rand -base64 32)
ONBUILD RUN bundle exec rake assets:precompile

# export env vars during run time
RUN mkdir -p /app/.profile.d/
RUN echo "cd /app/user/" > /app/.profile.d/home.sh
ONBUILD RUN echo "export PATH=\"$PATH\" GEM_PATH=\"$GEM_PATH\" GEM_HOME=\"$GEM_HOME\" RAILS_ENV=\"\${RAILS_ENV:-$RAILS_ENV}\" SECRET_KEY_BASE=\"\${SECRET_KEY_BASE:-$SECRET_KEY_BASE}\" BUNDLE_APP_CONFIG=\"$BUNDLE_APP_CONFIG\"" > /app/.profile.d/ruby.sh

COPY ./init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

ENTRYPOINT ["/usr/bin/init.sh"]

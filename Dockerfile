FROM heroku/cedar:14
MAINTAINER Terence Lee <terence@heroku.com>

RUN mkdir -p /app/user
WORKDIR /app/user

COPY ./heroku-docker-ruby-util /usr/local/bin/ruby-util
RUN chmod +x /usr/local/bin/ruby-util
RUN mkdir -p /app/heroku/ruby/

RUN mkdir -p /app/.profile.d/
RUN echo "cd /app/user/" > /app/.profile.d/home.sh

COPY ./init.sh /usr/bin/init.sh
RUN chmod +x /usr/bin/init.sh

ENTRYPOINT ["/usr/bin/init.sh"]

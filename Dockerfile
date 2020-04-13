FROM phusion/baseimage:latest

ENV APP_ENV production
ENV COMPLETED_PATH /output
ENV INCOMPLETE_PATH /download
ENV BUNDLER_VERSION 2.0.1

RUN mkdir -p /app
RUN mkdir -p /download
RUN mkdir -p /output
WORKDIR /app
STOPSIGNAL SIGRTMIN+3

RUN apt-get update && apt-get install -y curl wget python python-pip libtag1-dev ffmpeg apt-transport-https ruby-switch ruby2.5 ruby2.5-dev && \
  ruby-switch --set ruby2.5

RUN gem update --system && gem install bundler
COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install

COPY . /app
RUN pip install -r requirements.txt 

RUN mkdir /etc/service/server
ADD bin/server /etc/service/server/run
RUN chmod +x /etc/service/server/run

RUN mkdir /etc/service/sidekiq-single
ADD bin/sidekiq-single /etc/service/sidekiq-single/run
RUN chmod +x /etc/service/sidekiq-single/run

# Cleanup unused stuff
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 3000

CMD ["/sbin/my_init"]
FROM ruby:2.5.1

RUN apt-get update && apt-get install -y curl wget python python-pip libtag1-dev ffmpeg apt-transport-https

ENV APP_ENV production
ENV COMPLETED_PATH /output
ENV INCOMPLETE_PATH /download

RUN mkdir -p /app
RUN mkdir -p /download
RUN mkdir -p /output
WORKDIR /app
STOPSIGNAL SIGRTMIN+3

COPY Gemfile /app
COPY Gemfile.lock /app
RUN bundle install

COPY . /app
RUN pip install -r requirements.txt 


# Cleanup unused stuff
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 9292

CMD ["/bin/bash", "-l", "-c", "exec bundle exec rackup -o 0.0.0.0"]
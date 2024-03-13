FROM ruby

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y firefox-esr
RUN bundle
FROM ruby

WORKDIR /app

COPY ./frontend /app

RUN apt-get update && apt-get install -y firefox-esr
RUN bundle

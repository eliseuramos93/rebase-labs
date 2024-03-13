FROM ruby AS backend

WORKDIR /app

COPY ./backend /app
RUN bundle
FROM ruby:2.4.5-alpine3.8

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

WORKDIR /app

RUN apk add --no-cache --virtual .build-deps \
    make \
    gcc \
    libc-dev

COPY Gemfile* /app/


RUN bundle install

COPY . /app
CMD ["puma"]

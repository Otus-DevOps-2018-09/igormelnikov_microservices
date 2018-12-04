FROM ruby:2.4.5-alpine3.8

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

COPY Gemfile* /app/
WORKDIR /app

RUN apk add --no-cache --virtual .build-deps \
    make \
    g++ \
    libc-dev && \
    bundle install && \
    apk del .build-deps

COPY . /app

CMD ["puma"]

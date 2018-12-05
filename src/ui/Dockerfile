FROM ruby:2.4.5-alpine3.8

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

COPY Gemfile* /app/
RUN apk add --no-cache --virtual .build-deps \
    make \
    g++ \
    libc-dev && \
    bundle install --gemfile=/app/Gemfile && \
    apk del .build-deps

COPY . /app

WORKDIR /app
CMD ["puma"]

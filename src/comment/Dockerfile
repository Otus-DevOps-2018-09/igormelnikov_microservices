FROM ruby:2.4.5-alpine3.8

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments
ENV APPHOME /app/

COPY Gemfile* $APPHOME
RUN apk add --no-cache --virtual .build-deps \
    make \
    gcc \
    libc-dev && \
    bundle install --gemfile=/app/Gemfile && \
    apk del .build-deps

COPY . $APPHOME

WORKDIR $APPHOME
CMD ["puma"]

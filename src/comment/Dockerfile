FROM ruby:2.2
RUN apt-get update -qq \
 && apt-get install -y build-essential=11.7 --no-install-recommends \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

WORKDIR /app
COPY Gemfile* /app/
RUN bundle install
COPY . /app
CMD ["puma"]

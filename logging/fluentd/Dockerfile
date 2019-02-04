FROM fluent/fluentd:v0.12
USER root
RUN gem install fluent-plugin-elasticsearch --no-rdoc --no-ri --version 1.9.5 &&\
    gem install fluent-plugin-grok-parser --no-rdoc --no-ri --version 1.0.0 &&\
    gem install fluent-plugin-rewrite-tag-filter --no-rdoc --no-ri --version 1.6.0
COPY fluent.conf /fluentd/etc
USER fluent

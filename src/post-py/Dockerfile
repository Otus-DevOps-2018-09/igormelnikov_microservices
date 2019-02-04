FROM python:3.6.7-alpine3.8

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts
ENV APPHOME /app/post-py/

COPY requirements.txt "$APPHOME"
RUN apk add --no-cache --virtual .build-deps \
    gcc \
    musl-dev && \
    pip install -r "$APPHOME/requirements.txt" && \
    apk del .build-deps

COPY . $APPHOME

WORKDIR $APPHOME
CMD ["python3", "post_app.py"]

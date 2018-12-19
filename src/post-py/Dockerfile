FROM python:3.6.7-alpine3.8

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts
ENV APPHOME /app/

COPY requirements.txt "$APPHOME"
RUN pip install -r "$APPHOME/requirements.txt"

COPY . $APPHOME

WORKDIR $APPHOME
CMD ["python3", "post_app.py"]

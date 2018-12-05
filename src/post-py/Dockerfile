FROM python:3.6.7-alpine3.8

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

COPY requirements.txt /app/
RUN pip install -r /app/requirements.txt

COPY . /app

WORKDIR /app
CMD ["python3", "post_app.py"]

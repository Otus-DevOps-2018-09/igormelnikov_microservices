docker network create reddit
docker volume create reddit_db

docker run -d --rm --network=reddit --network-alias=post_db_host --network-alias=comment_db_host -v reddit_db:/data/db mongo:latest

docker run -d --rm --network=reddit --network-alias=post_srv_host \
-e POST_DATABASE_HOST='post_db_host' \
 igormelnikov/post:3.0

docker run -d --rm --network=reddit --network-alias=comment_srv_host \
-e COMMENT_DATABASE_HOST='comment_db_host' \
igormelnikov/comment:3.0

docker run -d --rm --network=reddit -p 9292:9292 \
-e POST_SERVICE_HOST='post_srv_host' \
-e COMMENT_SERVICE_HOST='comment_srv_host' \
igormelnikov/ui:3.0

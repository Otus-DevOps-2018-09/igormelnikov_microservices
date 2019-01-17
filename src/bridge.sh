docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24

docker volume create reddit_db

docker run -d --rm --network=back_net --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest

docker run -d --rm --network=back_net --name post igormelnikov/post:latest

docker run -d --rm --network=back_net --name comment igormelnikov/comment:latest

docker run -d --rm --network=front_net -p 9292:9292 --name ui igormelnikov/ui:latest

docker network connect front_net post
docker network connect front_net comment

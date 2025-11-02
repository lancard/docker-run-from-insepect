# docker-run-from-insepect
regenerate docker run from inspect

# usage
docker inspect --format "$(curl -s https://raw.githubusercontent.com/lancard/docker-run-from-insepect/refs/heads/master/run.tpl)" $container_id

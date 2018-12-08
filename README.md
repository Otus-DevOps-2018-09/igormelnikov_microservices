# igormelnikov_microservices
igormelnikov microservices repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices.svg?branch=docker-4)](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices)

## Docker-2

В директории `docker-monolith` находятся Dockerfile и файлы конфигурации для конфигурации и деплоя reddit приложения с помощью docker.

Внутри директории `docker-monolith/infra`:

 - `terraform` - поднятие нескольких инстансов GCE в количестве `count` и открытие порта 9292;
 - `ansible` - `playbook.yml` вызывает `docker.yml` для установки docker и `reddit.yml` для деплоя контейнера из образа `igormelnikov/otus-reddit:1.0`;
 - `packer` - шаблон packer, создающий образ с установленным docker, использует `docker.yml` для провиженинга.

## Docker-3

В директории `src` находятся конфигурации Docker контейнеров для компонентов приложения - `post`, `comment` и `ui`.

Файл `src/network.sh` содержит скрипты для создания сети и запуска контейнеров.

## Docker-4

Базовое имя проекта **docker-compose** задаётся флагом `-p` или переменной окружения `COMPOSE_PROJECT_NAME`. В противном случае, в качестве имени проекта используется имя директории проекта.

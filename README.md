# igormelnikov_microservices
igormelnikov microservices repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices.svg?branch=docker-1)](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices)

## Ansible-2

В директории `docker-monolith` находятся Dockerfile и файлы конфигурации для конфигурации и деплоя reddit приложения с помощью docker.

Внутри директории `docker/monolithinfra`:

 - `terraform` - поднятие нескольких инстансов GCE в количестве `count` и открытие порта 9292;
 - `ansible` - `playbook.yml` вызывает `docker.yml` для установки docker и `reddit.yml` для деплоя контейнера из образа `igormelnikov/otus-reddit:1.0`;
 - `packer` - шаблон packer, создающий образ с установленным docker, использует `docker.yml` для провиженинга.

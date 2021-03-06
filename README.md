# igormelnikov_microservices
igormelnikov microservices repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices.svg?branch=kubernetes-2)](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices)

## Docker-2

В директории `docker-monolith` находятся Dockerfile и файлы конфигурации для конфигурации и деплоя reddit приложения с помощью docker.

Внутри директории `infra-monolith`:

 - `terraform` - поднятие нескольких инстансов GCE в количестве `count` и открытие порта 9292;
 - `ansible` - `playbook.yml` вызывает `docker.yml` для установки docker и `reddit.yml` для деплоя контейнера из образа `igormelnikov/otus-reddit:1.0`;
 - `packer` - шаблон packer, создающий образ с установленным docker, использует `docker.yml` для провиженинга.

## Docker-3

В директории `src` находятся конфигурации Docker контейнеров для компонентов приложения - `post`, `comment` и `ui`.

Файл `src/network.sh` содержит скрипты для создания сети и запуска контейнеров.

## Docker-4

Базовое имя проекта **docker-compose** задаётся флагом `-p` или переменной окружения `COMPOSE_PROJECT_NAME`. В противном случае, в качестве имени проекта используется имя директории проекта.

В директории `src/git-sync` описан контейнер, автоматически подтягивающий ветку `microservices` из репозитория https://github.com/igormelnikov/reddit в общий том.

`docker-compose.override.yml` реализует запуск контейнеров `ui`, `comment`, `post`, зависящих от `git-sync`, и разделённого тома с кодом приложения между ними. Puma запускается с опциями отладки.

## Gitlab-ci-1

В директории `gitlab-ci/infra` находится конфигурация инфраструктуры под **Gitlab CI**:

 - `infra/terraform` - поднятие виртуальной машины на GCE;
 - `ansible/gitlab-ci.yml` - установка и запуск контейнера с Gitlab с помощью docker-compose;
 - `ansible/runners.yml` - запуск и регистрация раннеров на том же хосте, количество задаётся переменной `count`.

 Оповещения настроены в канале Slack: https://devops-team-otus.slack.com/messages/CDCDS945V/

## Gitlab-ci-2

Сервер с окружением создаётся при пуше ветки с постфиксом `-deploy`. Конфигурация хоста в GCE находится в `env/terraform`, для каждого хоста создаётся свой workspace, чтобы можно было удалить его с помощью `terraform destroy`. Провиженинг докера и деплой контейнеров описан в плейбуках в `env/ansible`.

Terraform и Ansible были использованы для деплоя, поскольку docker-machine создаёт хост с нуля, не проверяя его состояние, и хранит конфигурацию локально, а сервера окружений должны быть сохранены между пайплайнами. Terraform хранит конфигурацию в удалённом бакенде, а Ansible проверяет необходимость внесения изменений.

Образа контейнеров хранятся в Gitlab Registry на самом хосте, порт 4567. Настроен доступ по https, использована интеграция Gitlab с Let's Encrypt для получения сертификата. Поскольку лимит сертификатов на домены xip.io был исчерпан на данный период, использован бесплатный домен **gitlabcitest.tk**, указывающий на адрес Gitlab хоста. Для аутентификации используются job token при билде и deploy token при деплое.

Помимо конфигурации самого хоста в `gitlab-ci/infra/terraform` описаны правила для фаерволов с соответствующими тегами на хостах окружений (порт 4567 для registry, 9292 для приложения), а также бакет для бакенда окружений.

В самом приложении используется кастомный репозиторий igormelnikov/reddit, в котором добавлены `simpletest.rb` и `rack-test` для него.

Секретные переменные окружения:

- `GOOGLE_CREDENTIALS` - json-файл сервис аккаунта GCE
- `GOOGLE_APPUSER_KEY` - приватный файл ключа appuser
- `GCLOUD_PROJECT_NAME` - название проекта GCE.

## Monitoring-1

Докерхаб с образами
https://hub.docker.com/u/igormelnikov

Докерфайлы для **reddit** находятся в подиректориях `src`.

Конфигурация образа **Prometheus** находится в `monitoring/prometheus`.

**mongodb-exporter** собирается из исходников https://github.com/percona/mongodb_exporter в директории `monitoring/mongodb-exporter`.

Для **blackbox** используется готовый образ `prom/blackbox-exporter`.

В директории `docker` находятся Makefile для сборки и пуша образов в докерхаб и docker-compose.yml, запускающий **reddit** вместе с контейнерами для мониторинга.

Кастомные образы для мониторинга также собираются с помощью соответствующего `docker_build.sh`, чтобы использовать `build_info.txt` в качестве таргета для **make.**

## Monitoring-2

Мониторинг описан в отдельном файле `docker-compose-monitoring.yml`.

В директории `monitoring/grafana/dashboards` находятся созданные и импортированные шаблоны дэшбордов для мониторинга.

В Makefile добавлен билд и пуш сервисов мониторинга.

Добавлено снятие метрик с самого Docker сервиса. Для конфигурации на докер хост был добавлен `daemon.json`;

```
{
  "metrics-addr" : "10.132.0.13",
  "experimental" : true
}
```

Где `10.132.0.13` - локальный адрес докер хоста в GCE. Использован готовый коммьюнити дэшборд `Docker_Engine_Metrics.json`.

Docker отдаёт немного другие метрики, чем Cadvisor - в то время как первый собирает информации о состоянии докер сервиса в целом, второй анализирует каждый запущенный контейнер в отдельности.

Реализован сбор с метрик с помощью Telegraf. Поскольку коммьюнити дэшборды используют InfluxDB для снятия метрик, дэшборд `Telegraf_Monitoring.json` был взят из другого проекта.

Telegraf - кастомизируемый агент, использующий различные плагины для сбора и обработки метрик. Плагин для prometheus собирает ту же информацию, что и Prometheus - использование каждым контейнером CPU, оперативной памяти, сети, места на диске и т.д.

Реализован алерт на 95 процентиль времени ответа UI. Порог выбран очень близким к срабатыванию.

Настроена интеграция **Alertmanager** с электронной почтой, используется аккаунт gmail и app password.

## Logging-1

Добавлен стек логгирования EFK, описанный в `docker-compose-logging.yml`.

Конфигурация образа Fluentd находится в `logging/fluend`. Парсер настроен так, чтобы разбирать оба формата логов UI - они разделяются по тэгам в зависимости от ивента с помощью **rewrite_tag_filter,** и затем для каждого тэга применяется своё правило парсера.

В логгинг также добавлен сервис распределённого трейсинга Zipkin.


## Kubernetes-1

Вся стуктура расположена в директории `kubernetes`.

В сабдиректории `кeddit` описаны манифесты для **post**, **ui**, **comment** и **mongo**, пока нерабочие.

В `the_hard_way` находятся файлы, созданные в процессе прохождения туториала **Kubernetes The Hard Way.**

`the_hard_way/terraform` содержит описание Terraform для инфраструктуры туториала в GCE - инстансы, правила фаервола, адреса и проч.

`the_hard_way/ansible/playbook.yml` содержит пример конфигурации кластера для туториала с помощью Ansible - плейбук копирует заранее созданные ключи и сертификаты на соответствующие инстансы, а так же провиженит шаблон конфигурации для **etcd** сервиса и поднимает его на инстансах controller.

## Kubernetes-2

В директории `reddit` описаны манифесты компонентов reddit и сервисы для их связи между собой, а также `dev` окружение.

 - `ui-deployment.yml`, `post-deployment.yml`, `comment-deployment.yml`, `mongo-deployment.yml` - деплоймент основных компонентов приложения и базы данных;
 - `ui-service.yml` - описывает доступ к **ui** снаружи;
 - `comment-service.yml`, `post-service.yml` - описание сервисов **post** и **comment** для **ui**;
 - `comment-mongodb-service.yml`, `post-mongodb-service.yml` - описание сервисов БД для **post** и **comment**;
 - `dev-namespace.yml` - описание неймспейса **dev**.

## Kubernetes-3

 - `ui-ingress.yml` - описание Ingress для сервиса **ui**, доступ только по HTTPS;
 - `mongo-network-policy.yml` - описание политики сети для **mongodb**, ограничивающей входящий трафик отовсюду, кроме сервисов **post** и **comment**;
 - `mongo-volume.yml` - описание PersistentVolume для кластера, `mongo-claim.yml` - запрос на выделение места из него для **mongodb**;
 - `storage-fast.yml`, `mongo-claim-dynamic.yml` - описание StorageClass в GCE и Claim для него;
 - `mongo-deployment.yml` использует динамический Claim.

## Kubernetes-4

В директории `Charts` находятся Chartы Helm с шаблонами для манифестов **ui**, **comment**, **post**, каждый из которых содержит соответствующий deployment и service, ingress для ui.

`reddit` объединяет компоненты воедино и описывает зависимость mongo.

`gitlab-omnibus` содержит Chart для развёртывания Gitlab в Kubernetes, 

В код сервисов **ui**, **comment**, **post** в директории `src` добавлены файлы `.gitlab-ci.yml` для организации пайплайна в репозитории каждого сервиса. Пайплайн выполняет:

1. Build - сборку образа с тегом мастер
2. Test - фиктивное тестирование
3. Release - смену тега на тег из файла VERSION и пуш образа.

Review - По коммиту в feature-бранч создаётся динамическое окружение для деплоя приложения из build.

`.gitlab-ci.yml` в `Charts` деплоит уже собранные образы на статичные окружения.

## Kubernetes-5

`Charts/prometheus` содержит конфигурацию Prometheus для reddit в кластере.

`kubernetes/grafana/dashboards` содержит шаблонизированные дэшборды для reddit кластера.

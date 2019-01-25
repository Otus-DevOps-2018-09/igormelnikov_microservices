# igormelnikov_microservices
igormelnikov microservices repository

[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices.svg?branch=monitoring-1)](https://travis-ci.com/Otus-DevOps-2018-09/igormelnikov_microservices)

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

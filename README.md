
## Install

    $ cp .env.sample .env

Update `.env` with correct information

### DB Intial setup

    $ docker-compose run --rm db_initial

### Reset Encryption Key

    $ docker-compose run --rm reset_encryption_key

### SSH to container

    $ docker-compose run --rm bash

### Run with no SSL

    $ docker-compose up web_nossl

### RUN with SSL

    $ docker-compose up web

FROM python:3.6.4-slim

ENV APP_DIR /var/opt/app

RUN set -x && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    mysql-client \
    libmysqlclient-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pip install virtualenv

RUN useradd -m -s /bin/bash python
RUN echo 'python:password' | chpasswd
RUN mkdir -p ${APP_DIR} && \
    chown -R python:python ${APP_DIR}

ADD docker-entrypoint.sh ${APP_DIR}/docker-entrypoint.sh
RUN chown python:python ${APP_DIR}/docker-entrypoint.sh

ADD .bashrc /home/python/.bashrc
RUN chown python:python /home/python/.bashrc

USER python

WORKDIR ${APP_DIR}

EXPOSE 8000

ENTRYPOINT ["./docker-entrypoint.sh"]
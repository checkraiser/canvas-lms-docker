FROM    ubuntu:14.04
RUN     apt-get update -y

# Install dependencies
RUN     apt-get install --yes postgresql-9.3 git-core libapache2-mod-passenger apache2
RUN     apt-get install --yes software-properties-common
RUN     apt-add-repository --yes ppa:brightbox/ruby-ng
RUN     apt-get update -y
RUN     apt-get install --yes ruby2.1 ruby2.1-dev zlib1g-dev libxml2-dev \
                              libsqlite3-dev postgresql libpq-dev \
                              libxmlsec1-dev curl make g++

# Enable rewrite and passenger on Apache
RUN     a2enmod rewrite
RUN     a2enmod passenger
RUN     a2enmod ssl

# Install Redis
RUN     add-apt-repository ppa:chris-lea/redis-server
RUN     apt-get update -y
RUN     apt-get install --yes redis-server


# Install Python
RUN     apt-get install --yes build-essential checkinstall wget
RUN     apt-get install --yes libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev
RUN     cd /usr/src && wget https://www.python.org/ftp/python/2.7.10/Python-2.7.10.tgz && tar xzf Python-2.7.10.tgz
RUN     cd /usr/src/Python-2.7.10 && ./configure && make altinstall


# intall node
RUN     curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
RUN     apt-get install --yes nodejs

# get canvas and install
RUN     cd /var && git clone https://github.com/instructure/canvas-lms.git canvas && cd canvas && git branch --set-upstream-to origin/stable
RUN     cd /var/canvas && gem install bundler --version 1.7.11
RUN     cd /var/canvas && bundle install --path vendor/bundle --without=sqlite mysql

# copy config files
RUN     cd /var/canvas && for config in amazon_s3 database \
                          delayed_jobs domain file_store outgoing_mail security external_migration; \
                          do cp config/$config.yml.example config/$config.yml; done
RUN     cd /var/canvas && mkdir -p log tmp/pids public/assets public/stylesheets/compiled && touch Gemfile.lock

# compile static files
RUN     ln -s /usr/local/bin/python2.7 /usr/local/bin/python
RUN     cd /var/canvas && npm install

# Automation jobs
RUN     ln -s /var/canvas/script/canvas_init /etc/init.d/canvas_init
RUN     update-rc.d canvas_init defaults




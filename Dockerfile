FROM ruby:2.6.6

LABEL maintainer Travis CI GmbH <support+become-docker-images@travis-ci.com>

RUN mkdir -p /usr/local/etc;  {   echo 'install: --no-document';   echo 'update: --no-document';  } >> /usr/local/etc/gemrc

ENV RUBY_MAJOR=2.6
ENV RUBY_VERSION=2.6.6
ENV RUBY_DOWNLOAD_SHA256=5db187882b7ac34016cd48d7032e197f07e4968f406b0690e20193b9b424841f

RUN apt-get update;  apt-get install -y --no-install-recommends   autoconf   bison   dpkg-dev   gcc   libbz2-dev   libgdbm-compat-dev   libgdbm-dev   libglib2.0-dev   libncurses-dev   libreadline-dev   libxml2-dev   libxslt-dev   make   ruby   wget   xz-utils  ;  rm -rf /var/lib/apt/lists/*;   wget -O ruby.tar.xz "https://cache.ruby-lang.org/pub/ruby/${RUBY_MAJOR%-rc}/ruby-$RUBY_VERSION.tar.xz";  echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.xz" | sha256sum --check --strict;   mkdir -p /usr/src/ruby;  tar -xJf ruby.tar.xz -C /usr/src/ruby --strip-components=1;  rm ruby.tar.xz;   cd /usr/src/ruby;   {   echo '#define ENABLE_PATH_CHECK 0';   echo;   cat file.c;  } > file.c.new;  mv file.c.new file.c;   autoconf;  gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)";  ./configure   --build="$gnuArch"   --disable-install-doc   --enable-shared  ;  make -j "$(nproc)";  make install;   apt-mark auto '.*' > /dev/null;  apt-mark manual $savedAptMark > /dev/null;  find /usr/local -type f -executable -not \( -name '*tkinter*' \) -exec ldd '{}' ';'   | awk '/=>/ { print $(NF-1) }'   | sort -u   | xargs -r dpkg-query --search   | cut -d: -f1   | sort -u   | xargs -r apt-mark manual  ;  apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;cd /;  rm -r /usr/src/ruby;  ! dpkg -l | grep -i ruby;  [ "$(command -v ruby)" = '/usr/local/bin/ruby' ];  ruby --version;  gem --version;  bundle --version


ENV GEM_HOME=/usr/local/bundle
ENV BUNDLE_SILENCE_ROOT_WARNING=1 BUNDLE_APP_CONFIG=/usr/local/bundle
ENV PATH=/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.gem/ruby/2.6.0/bin

RUN apt-get update ; apt-get install -y --no-install-recommends git ca-certificates libssl-dev make gcc g++ libpq-dev && rm -rf /var/lib/apt/lists/*

RUN mkdir -p "$GEM_HOME"
RUN chmod 777 "$GEM_HOME"

RUN bundle config --global frozen 1

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile      /app
COPY Gemfile.lock /app
RUN gem install bundler:1.17.1
RUN bundler install --verbose --retry=3
RUN gem install --user-install executable-hooks
COPY . /app

CMD bundle exec ./script/server

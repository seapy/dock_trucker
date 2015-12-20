FROM seapy/ruby:2.2.0
MAINTAINER ChangHoon Jeong <iamseapy@gmail.com>

# Install AWS Command Line Interface
RUN apt-get install -y awscli

WORKDIR /app

#(required) Install App
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test
ADD . /app

CMD clockwork clock.rb

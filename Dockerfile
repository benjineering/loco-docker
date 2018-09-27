FROM ruby:2.3.1

# args
ARG mongohost=locodocker_db_1:27017

# nodejs
RUN apt-get update
RUN apt-get install -y nodejs

# gems
#RUN gem install bundler
RUN gem install --version "4.2.6" rails

# rails app
RUN rails new locomotiveapp --skip-bundle --skip-active-record
WORKDIR /locomotiveapp

# locomotive install
RUN echo "gem 'locomotivecms', '~> 3.1.1'" >> Gemfile
RUN echo "gem 'puma'" >> Gemfile
RUN bundle install
RUN bundle exec rails generate locomotive:install

# locomotive config
RUN sed -i -- "s/localhost:27017/$mongohost/g" /locomotiveapp/config/mongoid.yml

# start script
COPY start_app.sh /root/
RUN chmod +x /root/start_app.sh

EXPOSE 3000
ENTRYPOINT /root/start_app.sh

FROM ruby:2.6.10

WORKDIR /blog

COPY Gemfile .
COPY Gemfile.lock .
RUN gem install bundler && bundle install
EXPOSE 4000
CMD [ "jekyll", "serve", "--watch", "--host", "0.0.0.0" ]

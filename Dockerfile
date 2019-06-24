FROM ruby:2.6.2-alpine

RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

WORKDIR /app

COPY Gemfile* ./
RUN bundle install --without=development

COPY es-fetch.rb .

USER 1000

CMD "/app/es-fetch.rb"

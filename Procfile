FROM ruby:2.7.5-alpine
ADD Gemfile /app/
ADD Gemfile.lock  /app/
RUN bundle install
RUN rails db:create && rails db:migrate && rails db:seed
RUN --mount=type=cache,target=/root/.m2 mvn -o install 


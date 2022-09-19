FROM web: rake db:migrate && rake db:seed && bundle install && bin/rails server -b 0.0.0.0 -p {PORT:3000}
FROM maven:3.6.1-jdk-11 AS build
WORKDIR /
# copy just the pom.xml for cache efficiency
COPY ./pom.xml /
# go-offline using the pom.xml
RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline
# now copy the rest of the code and run an offline build
COPY . /
RUN --mount=type=cache,target=/root/.m2 mvn -o install 

FROM scratch
COPY --from=build /admin/admin-rest/target/admin-rest.war /webapps/ROOT.war
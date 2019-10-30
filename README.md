# RailsDocker
Docker and docker-compose to use https://github.com/mattbrictson/rails-template.

## How to use
Download docker-compose.yml and Dockerfile:

`curl https://raw.githubusercontent.com/nevware/RailsDocker/master/docker-compose.yml -o docker-compose.yml`
`curl https://raw.githubusercontent.com/nevware/RailsDocker/master/Dockerfile -o Dockerfile`

Once the containers are built, run `docker-compose run web rails new <<projectname>> . -d postgresql -m https://raw.githubusercontent.com/mattbrictson/rails-template/master/template.rb`

This will generate a new rails project using the template; it will ask a few questions on the command line.

The initiation will fail when creating databases, as the database config expects postgres to run locally.

Edit config/database.yml, and add
`  host: db
  user:postgres`
to both development and test.

Once that's worked, run `docker-compose run bin/setup`; this should complete the setup step.

Finally, you should be able to run `docker-compose up`.

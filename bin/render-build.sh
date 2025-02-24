#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails css:build
bundle exec rails javascript:build


# If you're using a Free instance type, you need to
# perform database migrations in the build command.
# Uncomment the following line:

# bundle exec rails db:migrate
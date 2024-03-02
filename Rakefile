#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Ecommerce::Application.load_tasks

namespace :db do
  desc 'Migrate the database (both development and test environments)'
  task migrate_all: [:environment, 'db:migrate', 'db:migrate RAILS_ENV=test'] do
    puts 'Migrations were run in both development and test environments'
  end
end

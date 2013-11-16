ENV=development

usage:
	@echo "USAGE:"
	@echo "  make init"
	@echo "  make bundle"
	@echo "  make precompile ENV=development"

init: bundle _init_db
	bundle exec rails g rspec:install
	@echo "NOTE: edit spec/spec_helper.rb as you like"
	bundle exec rake haml:replace_erbs

bundle:
	bundle install --path=./vendor/bundler

_init_db:
	mysql -uroot -p < db/init.sql
	bundle exec rake db:migrate

precompile:
	bundle exec rake assets:precompile RAILS_ENV=$(ENV)


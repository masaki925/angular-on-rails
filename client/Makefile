
usage:
	@echo "USAGE"
	@echo "  make init"
	@echo "  make bundle"
	@echo "  make gs (grunt server)"

init: bundle
	npm install
	bower install

bundle:
	bundle install --path=./vendor/bundler

gs:
	bundle exec grunt server


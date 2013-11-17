
usage:
	@echo "USAGE"
	@echo "  make npm_install"
	@echo "  make bundle"
	@echo "  make gs (grunt server)"

init_npm:
	npm install --save-dev grunt-connect-proxy
	npm install --save-dev connect-livereload
	npm install --save-dev grunt-ng-constant

bundle:
	bundle install --path=./vendor/bundler

gs:
	bundle exec grunt server


.PHONY: all deps format test lint compile

MIX_ENV:=$(or $(MIX_ENV), $(MIX_ENV), dev)

all: deps format test run

deps:
	@echo "\033[0m[make]\033[0;31m getting dependencies\033[0m" $<
	@MIX_ENV=test mix deps.get
	@echo "\033[0m[make]\033[0;33m compiling dependencies\033[0m" $<
	@MIX_ENV=test mix deps.compile

format: 
	@echo "\033[0m[make]\033[0;32m formatting code\033[0m" $<
	@mix format

test:
	@echo "\033[0m[make]\033[0;32m compiling code in environment: test\033[0m" $<
	@MIX_ENV=test mix compile
	@echo "\033[0m[make]\033[0;34m testing code in environment: test\033[0m" $<
	@MIX_ENV=test mix coveralls.html

lint:
	@echo "\033[0;32m[make]\033[0;95m linting code\033[0m" $<
	@mix credo --strict --verbose -a

compile:
	@echo "\033[0;32m[make]\033[0;33m compiling code in environment: $(MIX_ENV) \033[0m" $<
	@MIX_ENV=$(MIX_ENV) mix compile --force

run:
	iex -S mix

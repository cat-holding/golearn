OK_COLOR=\033[32;01m
NO_COLOR=\033[0m

IGNORE_COVERAGE_FOR='/test|/vendor'


all: format coverage clean

# Run application
run:
	echo -e "$(OK_COLOR)--> Running application$(NO_COLOR)"
	go run ./cmd/app

# Install dependencies
deps:
	echo -e "$(OK_COLOR)--> Downloading go.mod dependencies$(NO_COLOR)"
	go mod download

# Run tests
test:
	echo -e "$(OK_COLOR)--> Running unit tests$(NO_COLOR)"
	go test -covermode=atomic -coverprofile=coverage.out `go list ./... | grep -vE $(IGNORE_COVERAGE_FOR)`

# Basic code coverage with text output
coverage: test
	echo -e "$(OK_COLOR)--> Showing test coverage$(NO_COLOR)"
	go tool cover -func=coverage.out

# Open HTML coverage report in browser - with detailed line coverage
coverage-html: test
	go tool cover -html="coverage.out"

# Format Go files
format:
	echo -e "$(OK_COLOR)--> Formatting go files$(NO_COLOR)"
	go mod tidy
	go fmt ./...

# Remove coverage reports and temporary files
clean:
	echo -e "$(OK_COLOR)--> Clean up$(NO_COLOR)"
	rm -rf *.out *.tmp

.PHONY: deps test coverage coverage-html format clean

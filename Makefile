# vet
vet\:check: # Check error [synonym: check]
	@cargo check --all --verbose
.PHONY: vet\:check

check: vet\:check
.PHONY: check

vet\:format: # Show format diff [synonym: vet:fmt, format, fmt]
	@cargo fmt --all -- --check
.PHONY: vet\:format

vet\:fmt: vet\:format
.PHONY: vet\:fmt

format: vet\:format
.PHONY: format

fmt: vet\:format
.PHONY: fmt

vet\:lint: # Show suggestions relates to hygiene [synonym: lint]
	@cargo clippy --all-targets
.PHONY: vet\:lint

lint: vet\:lint
.PHONY: lint

vet\:all: check fmt lint # Run all vet targets
.PHONY: vet\:all

vet: vet\:check # Alias for vet:check
.PHONY: vet

# build
build\:asset\:debug:
	@npm run build-debug
.PHONY: build\:asset\:debug

build\:asset\:release:
	@npm run build-release
.PHONY: build\:asset\:release

build\:debug: build\:asset\:debug # Build (Run) a package [synonym: build]
	cargo run --features debug
.PHONY: build\:debug

build: build\:debug # Alias for build:debug
.PHONY: build

build\:release: build\:asset\:release # Build (Run) a package with release mode
	cargo run --release
.PHONY: build\:release

# util
watch: # Start a process to watch (require cargo-watch)
	cargo watch --exec 'run --features debug' --delay 0.3
.PHONY: watch

clean: # Remove built artifacts
	@rm -fr dst/*.html
	@rm -fr dst/**/*.{js,css}
	@cargo clean
.PHONY: clean

help: # Display this message
	@set -uo pipefail; \
	grep --extended-regexp '^[0-9a-z\:\\\%]+: ' \
		$(firstword $(MAKEFILE_LIST)) | \
		grep --extended-regexp ' # ' | \
		sed --expression='s/\([a-z0-9\-\:\ ]*\): \([a-z0-9\-\:\ ]*\) #/\1: #/g' | \
		tr --delete \\\\ | \
		awk 'BEGIN {FS = ": # "}; \
			{printf "\033[38;05;222m%-14s\033[0m %s\n", $$1, $$2}' | \
		sort
.PHONY: help

.DEFAULT_GOAL = build:release
default: beild\:release

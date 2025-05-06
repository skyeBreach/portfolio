set dotenv-load
set unstable
set shell := ["zsh", "-cu"]

# ================================================================================================ #
# Project Configration Helpers

project_path := justfile_directory()

# Project Paths
dir_scripts := project_path/"scripts"

# Docker Variables
docker_username := "skyebreach"
docker_image := "terminal_portfolio"

# ================================================================================================ #
# Command-Line Helpers

# Helper terminal command prefix to allow for easy just recipe calling
# This is required as Just doesnt natively allow recipes to call other recipes with dep
call_recipe := just_executable() + " --justfile=" + justfile()

# ================================================================================================ #
# Project Info

# Output usage and command info for the project
help:
    @just --list --alias-style=separate --justfile {{justfile()}}
_default: help

# Output current system information
@system-info:
    echo $'\n{{BOLD}}{{UNDERLINE}}System Info{{NORMAL}}'
    echo "    {{BOLD}}Architecture:{{NORMAL}} {{arch()}}"
    echo "    {{BOLD}}OS:{{NORMAL}} {{os()}}"
    echo "    {{BOLD}}OS Family:{{NORMAL}} {{os_family()}}"

# ================================================================================================ #
# Utility

# Removes all frequently generated files that are untracked
[group("utility")]
@clean:
    echo "  {{BOLD}}Running Cargo Clean:{{NORMAL}}"
    cargo clean

# Deep version of "clean", i.e. removes all generated files
[group("utility")]
@clean-deep: clean
    echo "  {{BOLD}}Removing Cargo.lock:{{NORMAL}}"
    (rm -f Cargo.lock && echo "     {{GREEN}}Removed{{NORMAL}} Cargo.lock")

# ================================================================================================ #
# Building

# Compiles the Leptos server and client
[group("build")]
@_build-site *args:
    echo "  {{BOLD}}Building the Leptos Project{{NORMAL}}"
    cargo leptos build {{args}}

# Compiles the Cargo project
[group("build")]
@_build-cargo *args:
    echo "  {{BOLD}}Building the Cargo Project{{NORMAL}}"
    cargo build

# Fully compiles the project for the development environement
[group("build")]
@build-dev +cargo-args="": && (_build-cargo cargo-args) (_build-site)
    echo "{{UNDERLINE}}{{BOLD}}Building Project for Development Environments{{NORMAL}}"

# Fully compiles the project as an optimized release build
[group("build")]
@build-rel +cargo-args="": && (_build-cargo "--release" cargo-args) (_build-site)
    echo "{{UNDERLINE}}{{BOLD}}Building Project for Release Environments{{NORMAL}}"
alias build := build-rel

# Deep cleans the project and compiles a fresh development build
[group("build")]
@rebuild-dev +cargo-args="": && clean-deep (_build-cargo cargo-args) (_build-site)
    echo "{{UNDERLINE}}{{BOLD}}Rebuilding Project for Development Environments{{NORMAL}}"

# Deep cleans the project and compiles a fresh release build
[group("build")]
@rebuild-rel +cargo-args="": && clean-deep (_build-cargo "--release" cargo-args) (_build-site)
    echo "{{UNDERLINE}}{{BOLD}}Rebuilding Project for Release Environments{{NORMAL}}"
alias rebuild := rebuild-rel

# ================================================================================================ #
# Deployment

# Serve and automatically reload the project when files change
[group("deploy")]
@dev:
    cargo leptos watch --hot-reload

# Serves the project in release mode
[group("deploy")]
@start:
    cargo leptos watch --hot-reload --release

# Bring the website up as a set of detached docker containers
[group("deploy")]
@up:
    docker compose up -d

# Take the website down and stop all detached docker containers
[group("deploy")]
@down:
    docker compose down

# ================================================================================================ #
# Docker

# Builds the tagged project docker image
[group("docker")]
@docker-build tag="latest" +args="":
    echo "{{BOLD}}Building Docker Image: {{docker_username}}/{{docker_image}}{{NORMAL}}"
    docker build -t {{docker_username}}/{{docker_image}}:{{tag}} . {{args}}

# Push the built tagged project docker image
[group("docker")]
@docker-push tag="latest" +args="":
    echo "{{BOLD}}Pushing Docker Image: {{docker_username}}/{{docker_image}}{{NORMAL}}"
    docker push {{docker_username}}/{{docker_image}}:{{tag}} {{args}}

# Rebuilds and pushes the tagged docker image
[group("docker")]
@docker-repush tag="latest" +build-args="":
    {{call_recipe}} docker-build {{tag}} {{build-args}}
    {{call_recipe}} docker-push

# ================================================================================================ #

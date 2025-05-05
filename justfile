set dotenv-load
set unstable
set shell := ["zsh", "-cu"]

# ================================================================================================ #
# Project Configration Helpers

project_path := justfile_directory()

# Important Project Paths
dir_scripts := project_path/"scripts"

# ================================================================================================ #
# Command-Line Helpers

# Helper terminal command prefix to allow for easy just recipe calling
# This is required as Just doesnt nativuly allow recipes to call other recipes with dep
call_recipe := just_executable() + " --justfile=" + justfile()

# ================================================================================================ #
# Project Info

# Output usage and helpful command info for the project
help:
    @just --list --alias-style=separate --justfile {{justfile()}}
_default: help

# Output current system information such as OS and Architecture
[group("info")]
@system-info:
    echo $'\n{{BOLD}}{{UNDERLINE}}System Info{{NORMAL}}'
    echo "    {{BOLD}}Architecture:{{NORMAL}} {{arch()}}"
    echo "    {{BOLD}}OS:{{NORMAL}} {{os()}}"
    echo "    {{BOLD}}OS Family:{{NORMAL}} {{os_family()}}"

# ================================================================================================ #
# Building

# Serve and automatically reload when files change (leptos watch)
[group("build")]
@dev:
    cargo leptos watch --hot-reload

# ================================================================================================ #

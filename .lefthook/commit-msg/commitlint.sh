#!/usr/bin/env zsh

echo $(head -n1 $1) | bun run commitlint --verbose --color --edit

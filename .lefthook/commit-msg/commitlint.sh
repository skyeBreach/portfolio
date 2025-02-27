#!/usr/bin/env bash

echo $(head -n1 $1) | bun run commitlint --verbose --color --edit

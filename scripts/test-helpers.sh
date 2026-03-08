#!/usr/bin/env bash

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." || exit 1; pwd -P)"

read_toml_value() {
	local file="$1"
	local key="$2"

	perl -lne "print \"\$1\" if /^${key}\\s*=\\s*\"(.*)\"/" < "$file"
}

typst_template_version() {
	local template_dir="$1"
	local toml_file="$ROOT/templates/$template_dir/typst.toml"
	local version

	if [[ ! -f "$toml_file" ]]; then
		echo "Missing template metadata: $toml_file" >&2
		return 1
	fi

	version="$(read_toml_value "$toml_file" "version")"
	if [[ -z "$version" ]]; then
		echo "Missing version in $toml_file" >&2
		return 1
	fi

	printf '%s\n' "$version"
}
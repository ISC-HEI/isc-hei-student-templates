#!/usr/bin/env bash
set -eu

echo "Removing tmp/isc-hei-bthesis if it exists..."
if rm -r tmp/isc-hei-bthesis 2>/dev/null; then
	echo "Removed tmp/isc-hei-bthesis successfully or it did not exist."
else
	echo "Failed to remove tmp/isc-hei-bthesis." >&2
fi

echo "Creating tmp directory if it does not exist..."
if mkdir -p tmp; then
	echo "tmp directory is ready."
else
	echo "Failed to create tmp directory." >&2
	exit 1
fi

cd tmp
typst init @preview/isc-hei-bthesis:0.6.0
cd isc-hei-bthesis
echo "Compiling bachelor thesis..."
typst compile bachelor_thesis.typ
echo "Compiling done"
cd ..
cd ..

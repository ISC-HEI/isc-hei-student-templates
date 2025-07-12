#!/usr/bin/env bash
set -eu

echo "Removing tmp/isc-hei-report if it exists..."
if rm -r tmp/isc-hei-report 2>/dev/null; then
  echo "Removed tmp/isc-hei-report successfully or it did not exist."
else
  echo "Warning: Failed to remove tmp/isc-hei-report." >&2
fi

echo "Creating tmp directory if it does not exist..."
if mkdir -p tmp; then
  echo "tmp directory is ready."
else
  echo "Error: Failed to create tmp directory." >&2
  exit 1
fi

cd tmp
typst init @preview/isc-hei-report:0.5.2
cd isc-hei-report
typst compile report.typ
cd ..
cd ..

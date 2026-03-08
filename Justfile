root := justfile_directory()

export TYPST_ROOT := root

[private]
default:
	@just --list --unsorted

# <!-- # generate manual
# doc:
# 	typst compile docs/manual.typ docs/manual.pdf

# # run test suite
# test *args:
# 	typst-test run {{ args }}

# # update test cases
# update *args:
# 	typst-test update {{ args }} -->

# install dev symlinks for all templates simultaneously
install-symblinks:
  ./scripts/dev_link "@preview" "bachelor-thesis"
  ./scripts/dev_link "@preview" "report"
  ./scripts/dev_link "@preview" "document"
  ./scripts/dev_link "@preview" "exec-summary"
  ./scripts/dev_link "@preview" "tb-assignment"

[private]
remove target:
  ./scripts/uninstall "{{target}}" "bachelor-thesis"
  ./scripts/uninstall "{{target}}" "report"
  ./scripts/uninstall "{{target}}" "document"
  ./scripts/uninstall "{{target}}" "exec-summary"
  ./scripts/uninstall "{{target}}" "tb-assignment"

# uninstalls the library from the "@local" prefix
# uninstall: (remove "@local")

# packs the library into the specified destination folders (report, bachelor and exec summary)
pack_distro target:  
  ./scripts/pack "{{target}}" "bachelor-thesis"
  ./scripts/pack "{{target}}" "report"
  ./scripts/pack "{{target}}" "document"
  ./scripts/pack "{{target}}" "exec-summary"
  ./scripts/pack "{{target}}" "tb-assignment"

# packs documents into different directories, for previewing and local testing
pack_distro_preview : (pack_distro "@preview")

# compiles all documents from src/ into examples/ (in parallel)
compile_all:
  typst compile src/bachelor_thesis.typ examples/bachelor_thesis.pdf &
  typst compile src/report.typ examples/report.pdf &
  typst compile src/document.typ examples/document.pdf &
  typst compile src/exec_summary.typ examples/exec_summary.pdf &
  typst compile src/tb_assignment.typ examples/tb_assignment.pdf &
  wait

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall: (remove "@preview")

# creates the thumbnails from the examples
generate_thumbs:
  convert -density 150 'examples/bachelor_thesis.pdf[0]' -flatten bachelor_thesis_thumb.png
  convert -density 150 'examples/report.pdf[0]' -flatten report_thumb.png
  convert -density 150 'examples/report.pdf[0]' -flatten document_thumb.png
  convert -density 150 'examples/exec_summary.pdf[0]' -flatten exec_summary.png
  convert -density 150 'examples/tb_assignment.pdf[0]' -flatten tb_assignment_thumb.png
  pngquant --quality 10-80 *.png --ext .png --force
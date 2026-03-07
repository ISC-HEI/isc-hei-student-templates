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

[private]
symblink target theme:
  ./scripts/dev_link "{{target}}" "{{theme}}"  

# create symblink for dev report
install-symblink-report: (symblink "@preview" "report")

# create symblink for simple document
install-symblink-document: (symblink "@preview" "document")

# create symblink for dev bachelor thesis
install-symblink-bthesis: (symblink "@preview" "bachelor-thesis")

# create symblink for executive summary
install-symblink-exec-summary: (symblink "@preview" "exec-summary")

[private]
remove target:
  ./scripts/uninstall "{{target}}" "bachelor-thesis"
  ./scripts/uninstall "{{target}}" "report"
  ./scripts/uninstall "{{target}}" "document"
  ./scripts/uninstall "{{target}}" "exec-summary"

# uninstalls the library from the "@local" prefix
# uninstall: (remove "@local")

# uninstalls the library from the "@preview" prefix (for pre-release testing)
uninstall: (remove "@preview")

# packs the library into the specified destination folders (report, bachelor and exec summary)
pack_distro target:  
  ./scripts/pack "{{target}}" "bachelor-thesis"
  ./scripts/pack "{{target}}" "report"
  ./scripts/pack "{{target}}" "document"
  ./scripts/pack "{{target}}" "exec-summary"

# packs documents into different directories, for previewing and local testing
pack_distro_preview : (pack_distro "@preview")

# creates the thumbnails from the examples
generate_thumbs:
  convert -density 150 'examples/bachelor_thesis.pdf[0]' -flatten bachelor_thesis_thumb.png
  convert -density 150 'examples/report.pdf[0]' -flatten report_thumb.png
  convert -density 150 'examples/report.pdf[0]' -flatten document_thumb.png
  convert -density 150 'examples/exec_summary.pdf[0]' -flatten exec_summary.png
  pngquant --quality 10-80 *.png --ext .png --force
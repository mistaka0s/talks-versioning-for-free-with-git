# VERSIONING Variables
VERSION_FILE = VERSION.yaml
VERSION_REGEX = version: (.*)


include *.make


.PHONY: present-local
present-local:
	@python -m SimpleHTTPServer&
	$(info "Started server on http://localhost:8000")

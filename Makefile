

.PHONY: present-local
present-local:
	@python -m SimpleHTTPServer&
    $(info "Started server on http://localhost:8000")

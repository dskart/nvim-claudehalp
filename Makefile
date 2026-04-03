.PHONY: lint fmt

lint:
	selene lua/ plugin/

fmt:
	stylua lua/ plugin/

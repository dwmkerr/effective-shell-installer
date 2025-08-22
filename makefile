.PHONY: test
test:
	echo "not yet implemented"
	echo 1

.PHONY: build
build:
	rm -rf build || true
	mkdir build
	cp effective.sh build/index.html

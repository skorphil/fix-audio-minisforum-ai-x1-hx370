.PHONY: build install uninstall clean

build:
	bash build.sh

install: build
	sudo ./hx370-audio-fix.sh --install

uninstall:
	sudo ./hx370-audio-fix.sh --uninstall

clean:
	rm -f hx370-audio-fix.sh

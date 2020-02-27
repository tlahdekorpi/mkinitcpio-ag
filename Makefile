VERSION = $(shell if test -f VERSION; then cat VERSION; else git describe | sed 's/-/./g;s/^v//;'; fi)

all: man/mkinitcpio.8 man/mkinitcpio.5 man/mkinitcpio.init.5

man/mkinitcpio.%: man/mkinitcpio.%.scd
	scdoc < $< > $@

install: all
	sed -e 's|\(^_devel\)=.*|\1=0|' -e 's|%VERSION%|$(VERSION)|g' \
		< mkinitcpio | install -Dm0755 /dev/stdin $(DESTDIR)/usr/bin/mkinitcpio

	install -dm755 $(DESTDIR)/usr/lib/mkinitcpio
	cp -at $(DESTDIR)/usr/lib/mkinitcpio install functions config

	install -Dm644 man/mkinitcpio.8 $(DESTDIR)/usr/share/man/man8/mkinitcpio.8
	install -Dm644 man/mkinitcpio.5 $(DESTDIR)/usr/share/man/man5/mkinitcpio.5
	install -Dm644 man/mkinitcpio.init.5 $(DESTDIR)/usr/share/man/man5/mkinitcpio.init.5
	install -Dm644 shell/bash-completion $(DESTDIR)/usr/share/bash-completion/completions/mkinitcpio
	install -Dm644 shell/zsh-completion  $(DESTDIR)/usr/share/zsh/site-functions/_mkinitcpio

.PHONY: all install

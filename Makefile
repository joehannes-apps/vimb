include config.mk

SRCDIR=src
DOCDIR=doc

all: $(TARGET)
options:
	@echo "$(PROJECT) build options:"
	@echo "LIBS    = $(LIBS)"
	@echo "CFLAGS  = $(CFLAGS)"
	@echo "LDFLAGS = $(LDFLAGS)"
	@echo "CC      = $(CC)"

test: $(LIBTARGET)
	@$(MAKE) $(MFLAGS) -s -C tests

clean:
	@$(MAKE) $(MFLAGS) -C src clean
	@$(MAKE) $(MFLAGS) -C tests clean

install: $(TARGET) $(DOCDIR)/$(MAN1)
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(SRCDIR)/$(TARGET) $(DESTDIR)$(BINDIR)/$(TARGET)
	install -d $(DESTDIR)$(DATADIR)/applications
	cp $(PROJECT).desktop $(DESTDIR)$(DATADIR)/applications
	install -d $(DESTDIR)$(EXAMPLEDIR)
	cp -r examples/* $(DESTDIR)$(EXAMPLEDIR)
	install -d $(DESTDIR)$(MANDIR)/man1
	@sed -e "s!VERSION!$(VERSION)!g" \
		-e "s!PREFIX!$(PREFIX)!g" \
		-e "s!DATE!`date +'%m %Y'`!g" $(DOCDIR)/$(MAN1) > $(DESTDIR)$(MANDIR)/man1/$(MAN1)

uninstall:
	$(RM) $(DESTDIR)$(BINDIR)/$(TARGET)
	$(RM) $(DESTDIR)$(DATADIR)/applications/$(PROJECT).desktop
	$(RM) $(DESTDIR)$(MANDIR)/man1/$(MAN1)
	$(RM) -r $(DESTDIR)$(EXAMPLEDIR)

dist: dist-clean
	@echo "Creating tarball."
	@git archive --format tar -o $(DIST_FILE) HEAD

dist-clean:
	$(RM) $(DIST_FILE)

$(TARGET):
	@$(MAKE) $(MFLAGS) -C src $(TARGET)

$(LIBTARGET):
	@$(MAKE) $(MFLAGS) -C src $(LIBTARGET)

.PHONY: clean all install uninstall options dist dist-clean test

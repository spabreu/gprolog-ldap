# $Id$
##############################

#DEBUG = -C -g -C -DDEBUG
DEBUG = 
LIBS  = -L -lldap

CFILES = proldap.c parse_dn.c
PLFILES = proldap.pl siiue2ldap.pl
BIN = add_alunos
BIN_LDIF = ldif_alunos
ASHELL = alunos_shell

FLAGS = --min-size
#FLAGS =

all: $(BIN) $(BIN_LDIF) $(ASHELL)

default: $(BIN)

$(BIN):	$(CFILES) $(PLFILES) Makefile init.pl
	gplc $(FLAGS) $(DEBUG) $(PLFILES) init.pl $(CFILES) $(LIBS) -o $(BIN)

$(BIN_LDIF) ldif:	$(CFILES) $(PLFILES) Makefile init_ldif.pl
	gplc $(FLAGS) $(DEBUG) $(PLFILES) init_ldif.pl $(CFILES) $(LIBS) -o $(BIN_LDIF)

$(ASHELL) shell:	$(CFILES) $(PLFILES) Makefile
	gplc $(DEBUG) $(PLFILES) $(CFILES) $(LIBS) -o $(ASHELL)

clean:
	rm -f *~ \#* core *.o

clean_all clean-all:	clean
			rm -f $(BIN)



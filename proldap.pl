% $Id$

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%         ProLDAP - API em Prolog para LDAP          %
%                                                    %
%     Pedro Patinho - Projecto de Fim de Curso       %
%        Universidade de Évora - 2000/2001           %
%                                                    %
%           ( parte II - API em Prolog )             %
%                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% l_init(+host, +port, -ldx)
:- foreign(l_init(+string, +positive, -integer)).

l_init(Server, LDX) :- l_init(Server, 389, LDX).
l_init(LDX) :- l_init(localhost, 389, LDX).


% l_bind(+ldx, +dn, +password)
:- foreign(l_bind(+integer, +string, +string)).

l_bind(LDX) :- l_bind(LDX, '','').


%l_add(+LD, +DN, +DADOS)
:- foreign(l_add(+integer, +string, +term)).

% EXEMPLO:
% l_add(LDX, 'cn=xpto,dc=uevora,dc=pt',
%	dados( 
%	       cn(xpto), 
%	       objectclass(top, account, posixAccount, shadowAccount,
%			   uevoraEntity, uevoraPerson)
%	       ).


:- foreign(l_del(+integer, +string)).

:- foreign(l_close(+integer)).

%l_search(+LDX, +BASE, +SCOPE, +FILTER, +ATTRS, +ATTRS_ONLY, -MSG_ID)
%
%LDX	inteiro c/ índice do link LDAP (p/ array interno)
%BASE	Átomo c/ base p/ pesquisa
%SCOPE	inteiro
%FILTER	Atomo c/ expressão de filtro (poderá ser construido em Prolog)
%ATTRS	lista de Atomos ou lista vazia (caso de lista vazia: retorna todos)
%	(nota: tentar alloca(3) em vez de malloc(3))
%ATTRS_ONLY	inteiro
%MSG_ID	inteiro

:- foreign(l_search(+integer, +string, +integer, +string, +term, +integer, -integer)).


%l_result(+LDX, +MSG_ID, +ALL, +TIMEOUT, -RES_TYPE, -RESULT)
%
%MSG_ID	inteiro, como anteriormente ou o valor num=E9rico de LDAP_RES_ANY
%ALL	inteiro, 0=3Dresultados um a um, 1=3Dtodos
%TIMEOUT	termo, possibilidades:
%		timeval(INTEIRO_sec, INTEIRO_usec)
%		INTEIRO_usec (0 equiv. a "infinito")
%RES_TYPE	inteiro, indica qual a fun=E7=E3o que iniciou
%RESULT	para usar em ldap_*_entry e ldap_count_entries

:- foreign(l_result(+integer, +integer, +integer, +integer, -integer, -integer)).


%l_msgfree(+MSG_ID)

:- foreign(l_msgfree(+integer)).

%l_count_entries(+LDX, +RESULT, -COUNT)
%
%COUNT	inteiro

:- foreign(l_count_entries(+integer,+integer,-integer)).

%l_entry(+LDX, +RESULT, -ENTRY)
%	[choice_size(1)]
%	n=E3o-deterministico, retorna as sucessivas entries.
%	guarda no choice-point o "next entry" (resultado do ldap_*_entry)
%
%ENTRY	inteiro
%:- foreign(l_entry(+integer, +integer, -integer), [choice_size(1)]).

% Não precisa de devolver nada porque o msg_id é sempre o mesmo
:- foreign(l_entry(+integer, +integer), [choice_size(1)]).

%l_attribute(+LD, +ENTRY, -ATRIB)
%	[choice_size(1)]
%	n=E3o-deterministico, retorna sucessivos atributos.
%	guarda no choice-point o "BerElement *"

%ATRIB	=E1tomo, nome do atributo, resultado de ldap_*_element

:- foreign(l_attribute(+integer, +integer, -string), [choice_size(1)]).

%l_values(+LD, +ENTRY, +ATRIB, +BINARY, -VALUES)

%BINARY	integer
%VALUES lista com os valores para o atributo ATRIB
%
:- foreign(l_values(+integer, +integer, +string, +integer, -term)).


%l_dn(+LD, +ENTRY, -DN)

:- foreign(l_dn(+integer, +integer, -term)).


%l_modify_*(+LD, +DN, +DADOS) --> DADOS é igual ao l_add
:- foreign(l_modify_add(+integer, +string, +term)).
:- foreign(l_modify_replace(+integer, +string, +term)).
:- foreign(l_modify_del(+integer, +string, +term)).

l_modify(LD, DN, DATA, a) :- l_modify_add(LD, DN, DATA).
l_modify(LD, DN, DATA, add)     :- l_modify_add(LD, DN, DATA).
l_modify(LD, DN, DATA, r) :- l_modify_replace(LD, DN, DATA).
l_modify(LD, DN, DATA, replace) :- l_modify_replace(LD, DN, DATA).
l_modify(LD, DN, DATA, d) :- l_modify_del(LD, DN, DATA).
l_modify(LD, DN, DATA, delete)  :- l_modify_del(LD, DN, DATA).


%l_modify_dn(+LD, +OLDDN, +NEWDN)
:- foreign(l_modify_dn(+integer, +string, +string)).

% debugging stuff
:- foreign(l_connections).
:- foreign(l_messages).

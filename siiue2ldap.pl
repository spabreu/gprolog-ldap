:- include('aluno.pl').
:- include('passwd.pl').

get_passwd(Pass) :- 
	get_key_no_echo(Char),
	get_passwd_aux(Char, Pass).

get_passwd_aux(-1, []) :- !.
get_passwd_aux(10, []) :- !.
get_passwd_aux(13, []) :- !.
 
get_passwd_aux(Char, [Char|Rest]) :- 
	get_passwd(Rest).

start :-
	write('Introduza a password do administrador LDAP'), nl,
	get_passwd(PASS),
	atom_codes(PASSWD, PASS),
	write('A ligar... '), 
	(
	    (connect(PASSWD, LDX), write('OK.'), nl) ;
	    (write('Falhou a ligação.'), nl, !, fail)
	),
	g_assign(ldx, LDX),
	(output_alunos;	write('FALHOU QUALQUER COISA'), nl).

output_alunos :-
	g_read(ldx, LDX), !,
	aluno(Num, Nome),
	password(Num, Pass),
	write(Num),
	nl,
	format_to_atom(UID, "l~d", [Num]),
	format_to_atom(DN, "uid=~a, dc=di, dc=uevora, dc=pt", [UID]),
	format_to_atom(HOME, "/home/aluno/~a", [UID]),
	format_to_atom(GECOS, "~a,,,", [Nome]),
	format_to_atom(USERPASS, "{crypt}~a", [Pass]),
        format_to_atom(UIDNUM, "~d", [Num]),
        l_add(LDX, DN,
	  dados(
	    uid(UID),
            cn(Nome),
	    objectClass(account, posixAccount, top, shadowAccount),
	    shadowMax('99999'),
	    shadowWarning('7'),
	    loginshell('/bin/bash'),
	    uidnumber(UIDNUM),
	    gidnumber('1013'),
	    homedirectory(HOME),
	    gecos(GECOS),
	    userpassword(USERPASS),
	    shadowLastChange('11500')
	  )
        ),
	fail.

output_alunos :- !.

connect(PASSWORD, LDX) :-
    l_init('127.0.0.1', LDX),
    l_bind(LDX, 'cn=admin, dc=di, dc=uevora, dc=pt', PASSWORD).

start_ldif :- output_alunos_ldif.

output_alunos_ldif :-
	aluno(Num, Nome),
	password(Num, Pass),
	format("dn: uid=l~d,ou=People,dc=alunos,dc=di,dc=uevora,dc=pt", [Num]), nl,
	format("uid: l~d", [Num]), nl,
	format("cn: ~a", [Nome]), nl,
	write('objectClass: account'), nl,
	write('objectClass: posixAccount'), nl,
	write('objectClass: top'), nl,
	write('objectClass: shadowAccount'), nl,
	write('shadowMax: 99999'), nl,
	write('shadowWarning: 7'), nl,
	write('loginShell: /bin/bash'), nl,
        format("uidNumber: ~d", [Num]), nl,
	write('gidNumber: 1013'), nl,
	format("homeDirectory: /home/aluno/l~d", [Num]), nl,
	format("gecos: ~a,,,", [Nome]), nl,
	format("userPassword: {crypt}~a", [Pass]), nl,
	write('shadowLastChange: 11500'), nl, nl
	    , fail.

output_alunos_ldif :- !.


adicionar :-
    g_read(ldx, LDX),
    l_add(LDX,
	  'cn=teste,dc=di,dc=uevora,dc=pt', 
	  dados(
		cn(teste),
		sn(teste),
		objectclass(top,person),
		telephonenumber('123-456789')
		)
	  ).
    

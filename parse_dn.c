// $Id$ --C--

#include <stdio.h>
#include <string.h>
#include <gprolog/gprolog.h>
#include <ldap.h>

#define MAXSTRSIZE   1024    /* max size of an allocated string */
#define MAXDNATTRS   25      /* max number of attributes a DN may have */


/* returns the string that's on the left of the '=' symbol (allocated) */
char *attr_left(char *attr)
{
  int s = strlen(attr);
  int i;
  char *ret = (char *) malloc (s * sizeof(char));

  for (i = 0; attr[i] != '='; i++) {
    ret[i] = attr[i];
  }
  ret[i] = '\0';

  return ret;
}

/* returns the string that's on the right of the '=' symbol (allocated) */
char *attr_right(char *attr)
{
  int s = strlen(attr);
  int i, j;
  char *ret = (char *) malloc (s * sizeof(char));

  for (i = 0; attr[i] != '='; i++) {
  }
  for(j = i+1; attr[j] != '\0'; j++) {
    ret[j-i-1] = attr[j];
  }
  ret[j-i-1] = '\0';

  return ret;
}

void parse_dn(char *dn, PlTerm *outlist)
{
  char **exploded_dn;
  char *p1[MAXDNATTRS], *p2[MAXDNATTRS];
  int i;
  PlTerm compound[MAXDNATTRS][2];
  PlTerm list[MAXDNATTRS];
   
  exploded_dn = ldap_explode_dn(dn, 0);

  for (i = 0; exploded_dn[i]; i++) {
    p1[i] = attr_left(exploded_dn[i]);
    p2[i] = attr_right(exploded_dn[i]);
    compound[i][0] = Mk_String(p1[i]);
    compound[i][1] = Mk_String(p2[i]);

    list[i] = Mk_Compound(Create_Atom("="), 2, compound[i]) ;
    
  }
  *outlist = Mk_Proper_List(i, list);

  for(--i; i>=0; i--) {
    free(p1[i]);
    free(p2[i]);
  }
}

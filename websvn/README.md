docker-websvn
=============

Websvn browser UI for accessing subversion repositories. Websvn expects all
hosted subversion repositories to be available under the /svn volume and
the htpasswd file to be /svn/svn.htpasswd. The AuthName defaults to "SVN"
and can be changed by setting the environment variable AUTH_NAME to
the desired name. Repository authentication is handled by the file /svn/svn.authz. The web site is available from the container at the port 80 root path ("/"). If you want it under a different path or encrypted using TLS/SSL then a front end proxy can supply the functionality. In addition, you can set the environment variables SVN_UID and SVN_GID to control the user and group that will be accessing the archives (and htpasswd). You can customize a short message by placing it in /svn/websvn.txt.

```
<Location />
  AuthType Basic
  AuthBasicProvider ldap
  AuthName "SVN"
  AuthLDAPUrl "ldap://10.1.8.12/DC=testing,DC=local?sAMAccountName?sub?(objectClass=Person)"
  AuthLDAPBindDN "svnuser@testing.local"
  AuthLDAPBindPassword svn@PaS#
  require valid-user
</Location>

```
In summary:
* /svn is the parent directory for the reporitories
* /svn/svn.htpasswd is the login password file
* /svn/svn.authz is the repository authentication file
* /svn/websvn.txt is a short message

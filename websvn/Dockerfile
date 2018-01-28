FROM ubuntu:trusty
MAINTAINER Chris Hardekopf <chrish@basis.com>
MAINTAINER Leonardo Silva <leogsilva@gmail.com>

# Arguments for websvn.conf ldap authentication
ENV ldap_host=""
ENV ldap_bind_dn=""
ENV ldap_bind_pass=""
ENV ldap_uri=""

# Install websvn
RUN apt-get update && apt-get install -y wget curl
RUN sh -c 'echo "deb http://opensource.wandisco.com/ubuntu `lsb_release -cs` svn19" >> /etc/apt/sources.list.d/subversion19.list'
RUN wget -q http://opensource.wandisco.com/wandisco-debian.gpg -O- | sudo apt-key add -

# Mustache download
RUN curl -sSL https://git.io/get-mo -o mo && mv mo /bin && chmod +x /bin/mo && echo "works" | mo

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget websvn \
    apache2-utils libapache2-svn && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get install -y subversion


# Replace the http URL in wsvn.php
RUN perl -pi -e \
    "s/^\\\$locwebsvnhttp =.+;\$/\\\$locwebsvnhttp = '';/g" \
    /etc/websvn/wsvn.php

# Use parent path for svn archives
RUN perl -pi -e \
    "s/\/\/ \\\$config->parentPath([^,]+);\$/\\\$config->parentPath('\/svn');/g" \
    /etc/websvn/config.php
# Enable MultiViews
RUN perl -pi -e \
    "s/\/\/ \\\$config->useMultiViews([^,]+);\$/\\\$config->useMultiViews();/g" \
    /etc/websvn/config.php
# Set up auth
RUN perl -pi -e \
    "s/\/\/ \\\$config->useAuthenticationFile([^,]+);/\\\$config->useAuthenticationFile('\/svn\/svn.authz');/g" \
    /etc/websvn/config.php

# Add the websv apache configuration and enable the site
ADD websvn.conf.mustache /etc/apache2/sites-available/
RUN a2enmod expires auth_digest authz_groupfile ldap authnz_ldap && \
    a2dissite 000-default

# Add the start script
ADD start /opt/
ADD update_websvn.sh /opt/
RUN chmod +x /opt/update_websvn.sh
RUN cp /etc/apache2/mods-available/authnz_ldap.load /etc/apache2/mods-available/mods-enabled

# Archives and configuration are stored in /svn
VOLUME [ "/svn" ]

# Expose public port for web server
EXPOSE 80

CMD /opt/update_websvn.sh && apachectl -D FOREGROUND

#!/bin/bash
# Initialize the configuration and start the web server.

/bin/mo /etc/apache2/sites-available/websvn.conf.mustache > /etc/apache2/sites-available/websvn.conf && /opt/start && a2ensite websvn

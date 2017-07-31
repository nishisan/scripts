#DOMAIN: #DOMAINNAME
<VirtualHost *:80>
        ServerName #DOMAINNAME
        ServerAlias  www.#DOMAINNAME
        # this is where requests for / go
        DocumentRoot #HOMEDIR/public_html

        # here you tell which user (myhost) and group (ftponly) Apache should use
        SuexecUserGroup #USER #GROUP

        suPHP_Engine on
        suPHP_UserGroup #USER #GROUP
        AddHandler x-httpd-php .php
        suPHP_AddHandler x-httpd-php

        # the following are optional but might be of use for you
        ScriptAlias /cgi-bin/ #HOMEDIR/public_html/cgi-bin
        php_admin_value open_basedir #HOMEDIR/public_html
        php_admin_value upload_tmp_dir  #HOMEDIR/tmp
        # Safe mode will be removed as of PHP 6. You may want to not enable it.
        <Directory "#HOMEDIR/public_html">
                AllowOverride All
                Order allow,deny
                Allow from all
                Options +SymlinksIfOwnerMatch +Includes
        </Directory>
         LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" varnish
        SetEnvIf X-Forwarded-For "^.*\..*\..*\..*" forwarded
        ErrorLog  #HOMEDIR/access-logs/error.log
        CustomLog #HOMEDIR/access-logs/access_log combined env=!forwarded
        CustomLog #HOMEDIR/access-logs/access_log varnish env=forwarded

</VirtualHost>
#DOMAIN END

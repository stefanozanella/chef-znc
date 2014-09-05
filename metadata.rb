name             'znc'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures znc'
long_description 'Installs/Configures znc'
version          '0.1.0'

attribute 'user',
  :display_name => 'IRC User',
  :description => 'User credentials used to connect to IRC',
  :type => 'string',
  :required => 'required',
  :recipes => [ 'znc::default' ]

depends "yum-epel"

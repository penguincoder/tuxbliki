#!/bin/bash

if [[ $# -ne 1 ]] ; then
  echo Usage: $0 [username]
  exit 1
fi

merb -i << EOF
a = Author.create :name => '$1', :password => 'password', :password_confirmation => 'password'
p = Permission.find_by_name('change_permissions')
p ||= Permission.create :name => 'change_permissions'
a.permissions << p
EOF

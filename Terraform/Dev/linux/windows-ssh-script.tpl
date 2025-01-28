add-content -path c:/users/cyril/.ssh/config -value @"

Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile ${identityfile}
"@

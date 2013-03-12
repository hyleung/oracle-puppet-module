class oracle::config {
    exec {
        "configure xe":
            command => "/etc/init.d/oracle-xe configure responseFile=/files/xe.rsp >> /tmp/xe-install.log",
            require => [Class["oracle::install"],Exec["oracle-shm"]],
            creates => "/u01/app/oracle/oradata",
            user => root;
        "update-rc oracle-shm":
            command => "/usr/sbin/update-rc.d oracle-shm defaults 01 99",
            cwd => "/etc/init.d",
            user => root,
            require => Class["oracle::install"],
            unless => "/usr/sbin/update-rc.d -n oracle-shm defaults|grep 'already exist'";
        "oracle-shm":
            command => "/etc/init.d/oracle-shm start",
            user => root,
            unless => "/usr/sbin/service oracle-shm status",
            require => [Class["oracle::install"],Exec["update-rc oracle-shm"]]; 
        "oracle-xe":
            command => "/etc/init.d/oracle-xe start",
            user => root,
            unless => "/usr/sbin/service oracle-xe status",
            require => [Exec["configure xe"],Exec["oracle-shm"]]; 
    }    
}
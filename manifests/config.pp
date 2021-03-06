class oracle::config {
    exec {
        "configure xe":
            command => "/etc/init.d/oracle-xe configure responseFile=/files/xe.rsp >> /tmp/xe-install.log",
            require => [Class["oracle::install"],Exec["oracle-shm"]],
            creates => "/u01/app/oracle/oradata",
            user => root,
            notify => File["/etc/profile.d/set_oracle_env.sh"];
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
        "update-rc oracle-xe":
            command => "/usr/sbin/update-rc.d oracle-xe defaults",
            cwd => "/etc/init.d",
            user => root,
            require => Class["oracle::install"],
            unless => "/usr/sbin/update-rc.d -n oracle-xe defaults|grep 'already exist'";            
    } 

    file {
    "/etc/profile.d/set_oracle_env.sh":
        ensure => present,
        source => "puppet:///modules/oracle/set_oracle_env.sh";
  } 
  
}
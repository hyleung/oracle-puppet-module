class oracle::service {
    service { 
        "oracle-shm":        
            ensure => running,
            hasrestart => false,                
            hasstatus => true,
            require => Class["oracle::config"];
        "oracle-xe":
            ensure => running,            
            hasstatus => true,
            hasrestart => true,
            require => Class["oracle::config"];
    }
}
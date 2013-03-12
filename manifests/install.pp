class oracle::install inherits oracle::params {
    file {    
        "/etc/sysctl.d/60-oracle.conf":
            source => "puppet:///modules/oracle/xe-sysctl.conf";
        "/files":
            ensure => directory;
        "/files/${rpm_file}.zip":
            ensure => present,
            source => "puppet:///modules/oracle/${rpm_file}.zip";
        "/files/xe.rsp":
            ensure => present,
            source => "puppet:///modules/oracle/xe.rsp";
        "/etc/init.d/oracle-shm":
            ensure => present,
            mode => 0755,
            source => "puppet:///modules/oracle/oracle-shm";
        "/sbin/chkconfig":
            ensure => present,
            mode => 0755,
            source => "puppet:///modules/oracle/chkconfig.sh";
        "/bin/awk":
            ensure => link,
            target => "/usr/bin/awk";
        "/var/lock/subsys":
            ensure => directory;
    }

    exec {
        # unpack the rpm
        "unzip xe":
            alias => "unzip xe",
            command => "/usr/bin/unzip -o /files/${rpm_file}.zip",
            require => [Package["unzip"],File["/files/${rpm_file}.zip"]],
            cwd => "/files",
            user => root,
            creates => "/files/Disk1/${rpm_file}";
        # convert the RPM to a debian package
        "alien xe":
            command => "/usr/bin/alien --to-deb --scripts /files/Disk1/${rpm_file}",
            cwd => "/files/Disk1",    
            require => Exec["unzip xe"],
            creates => "/files/Disk1/${deb_file}",
            user => root;
    }
    # install the oracle package
    package {
        "oracle-xe":
            provider => "dpkg",
            ensure => installed,
            require => Exec["alien xe"],
            source => "/files/Disk1/${deb_file}";
    }
}
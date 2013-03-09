class oracle::server {
  exec {
    "/usr/bin/apt-get -y update":
      alias => "aptUpdate",
      timeout => 3600;
  }

  package {
    "ntp":
      ensure => installed;
    "htop":
      ensure => installed;
    "unzip":
      ensure => installed;
    "monit":
      ensure => installed;
    "rsyslog":
      ensure => installed;
    "curl":
      ensure => installed;
    "alien":
      ensure => installed;
    "libaio1":
      ensure => installed;
    "unixodbc":
      ensure => installed;
    "git":
      ensure => installed;
  }

  service {
    "ntp":
      ensure => stopped;
    "monit":
      ensure => running;
    "rsyslog":
      ensure => running;
    "procps":
      ensure => running;
  }

  file {
    "/etc/sysctl.d/60-oracle.conf":
      source => "puppet:///modules/oracle/xe-sysctl.conf";
  }

  user {
    "syslog":
      ensure => present,
      groups => ["syslog","adm"];
  }
  
  group {
    "puppet":
      ensure => present;
  }
}

class oracle::xe {
  file {    
    "/files":
      ensure => directory;
    "/files/oracle-xe-11.2.0-1.0.x86_64.rpm.zip":
      ensure => present,
      source => "puppet:///modules/oracle/oracle-xe-11.2.0-1.0.x86_64.rpm.zip";
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
      command => "/usr/bin/unzip -o /files/oracle-xe-11.2.0-1.0.x86_64.rpm.zip",
      require => [Package["unzip"],File["/files/oracle-xe-11.2.0-1.0.x86_64.rpm.zip"]],
      cwd => "/files",
      user => root,
      creates => "/files/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm";
      # convert the RPM to a debian package
    "alien xe":
      command => "/usr/bin/alien --to-deb --scripts /files/Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm",
      cwd => "/files/Disk1",    
      require => Exec["unzip xe"],
      creates => "/files/Disk1/oracle-xe_11.2.0-2_amd64.deb",
      user => root;
  }
  # install the oracle package
  package {
    "oracle-xe":
      provider => "dpkg",
      ensure => installed,
      require => Exec["alien xe"],
      source => "/files/Disk1/oracle-xe_11.2.0-2_amd64.deb";
  }

  exec {
    "configure xe":
      command => "/etc/init.d/oracle-xe configure responseFile=/files/xe.rsp >> /tmp/xe-install.log",
      require => [File["/files/xe.rsp"],File["/etc/sysctl.d/60-oracle.conf"],  Package["oracle-xe"],Exec["oracle-shm"]],
      creates => "/u01/app/oracle/oradata",
      user => root;
    "update-rc oracle-shm":
      command => "/usr/sbin/update-rc.d oracle-shm defaults 01 99",
      cwd => "/etc/init.d",
      require => File["/etc/init.d/oracle-shm"],
      user => root,
      unless => "/usr/sbin/update-rc.d -n oracle-shm defaults|grep 'already exist'";
    "oracle-shm":
      command => "/etc/init.d/oracle-shm start",
      user => root,
      unless => "/usr/sbin/service oracle-shm status",
      require => Exec["update-rc oracle-shm"]; #only want this executing before configure
    "oracle-xe":
      command => "/etc/init.d/oracle-xe start",
      user => root,
      unless => "/usr/sbin/service oracle-xe status",
      require => [Exec["configure xe"],Exec["oracle-shm"]]; #shouldn't need this one
  }

}

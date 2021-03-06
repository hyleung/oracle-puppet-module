class oracle::server {
  exec {
    "/usr/bin/apt-get -y update":
      alias => "aptUpdate",
      timeout => 3600;
  }

  package {
    "ntp":
      ensure => installed;
    "bc":
      ensure => installed;
    "htop":
      ensure => installed;
    "monit":
      ensure => installed;
    "rsyslog":
      ensure => installed;
    "curl":
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
      ensure => stopped,
      require => Package["ntp"];
    "monit":
      ensure => running,
      require => Package["monit"];
    "rsyslog":
      ensure => running;
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
  require oracle::params
  include oracle::prereq
  include oracle::install, oracle::config, oracle::service


}

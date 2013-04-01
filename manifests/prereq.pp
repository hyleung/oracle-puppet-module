class oracle::prereq {
    if !defined(Package[alien]) {
    package {
        "alien":
      ensure => installed;
    }        
    }

}
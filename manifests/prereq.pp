class oracle::prereq {
    if !defined(Package[alien]) {
        package {
            "alien":
            ensure => installed;
        }        
    }
    if !defined(Package[unzip]) {
        package {
            "unzip":
            ensure => installed;
        }
    }

}
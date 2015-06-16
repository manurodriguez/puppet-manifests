class galera {

$first_ip = "192.168.1.2"
$second_ip = "192.168.1.3"
$third_ip = "192.168.1.4"

yumrepo { "mariadb":
baseurl => "http://yum.mariadb.org/10.0/centos7-amd64/",
gpgkey=> "https://yum.mariadb.org/RPM-GPG-KEY-MariaDB",
descr => "MariaDB",
enabled => 1,
gpgcheck => 1,
}

exec { 'yum-repolist':
  command => '/usr/bin/yum repolist'
}

package { 'galera':
  require => Exec['yum-repolist'], 
  ensure => installed,
}

package { 'MariaDB-Galera-server':
  ensure => installed,
}

package { 'MariaDB-client':
  ensure => installed,
}

package { 'MariaDB-shared':
  ensure => installed,
}

service { 'mysql':
  ensure => running,
  enable => true
}

exec { 'mysqlpass':
  command => '/usr/bin/mysqladmin -u root password voila123'
}

# copy the .my.cnf file to remote server
file { "/root/.my.cnf":
    mode   => 440,
    owner  => root,
    group  => root,
    source => "puppet:///modules/galera/mysqlpass.txt"
}

file { '/etc/my.cnf.d/cluster.conf':
    owner   => root,
    group   => root,
    mode    => 644,
    content  => template("galera/galera_config.erb")
}

}

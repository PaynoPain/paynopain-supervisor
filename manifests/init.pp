# Class: supervisor

class supervisor {

  package { 'supervisor':
    ensure   => 'latest'
  }

  # install start/stop script
  file { '/etc/init.d/supervisord':
    source => "puppet:///modules/supervisor/${::osfamily}.supervisord",
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/var/log/supervisor':
    ensure  => directory,
    purge   => true,
    backup  => false,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['supervisor'],
  }

  file { "/etc/supervisor/supervisord.conf":
    ensure  => file,
    content => template('supervisor/supervisord.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['supervisor'],
    notify  => Service['supervisord'],
  }

  file { "/etc/supervisor/conf.d/":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File["/etc/supervisor/supervisord.conf"],
  }

  service { 'supervisord':
    ensure     => 'running',
    hasrestart => true,
    require    => File["/etc/supervisor/supervisord.conf"],
  }
}

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
    ensure  => 'directory',
    purge   => true,
    backup  => false,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['supervisor'],
  }

  file { "${path_config}/supervisord.conf":
    ensure  => 'file',
    content => template('supervisor/supervisord.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['supervisor'],
    notify  => Service['supervisord'],
  }

  file { "${path_config}/supervisord.d":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File["${path_config}/supervisord.conf"],
  }

  service { 'supervisord':
    ensure     => 'running',
    enable     => true,
    hasrestart => true,
    require    => File["${path_config}/supervisord.conf"],
  }
}

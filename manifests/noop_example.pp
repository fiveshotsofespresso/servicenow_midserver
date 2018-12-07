file {'/tmp/1/2':
  require => File['/tmp/1'],
  ensure => directory,

}

file {'/tmp/1':
  ensure => directory,
  noop =>true,
}

file {'/tmp':
  ensure  => directory,
}

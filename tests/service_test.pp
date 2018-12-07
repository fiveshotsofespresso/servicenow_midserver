notify { "m: ${modulepath}": }

/*
class {'chocolatey':
  chocolatey_download_url         => 'https://som2.som.nats.co.uk/som4dml/data/DML000085/chocolatey.0.10.11.nupkg',
  use_7zip                        => false,
  choco_install_timeout_seconds   => 2700,
}

$chocolateysource = 'c:/windows/temp/chocolateysource'

file { $chocolateysource: ensure => directory, before => Chocolateysource['local'] }

chocolateysource {'local':
  ensure   => present,
  require  => Class['chocolatey'],
  location => $chocolateysource,
  before   => Class['servicenow_midserver'],
}

class { 'servicenow_midserver':
  package_name            => 'servicenow-midserver-kingston',
  package_version         => '1.6.1',
  package_source          => 'https://som2.som.nats.co.uk/som4dml/data/DML000084/servicenow-midserver-kingston.1.6.1.nupkg',
  midserver_name          => 'Discovery_MID1',
  midserver_home          => 'c:/ServiceNow',
  servicenow_username     => 'foo',
  servicenow_password     => 'bar',
  servicenow_url          => 'https://myinstance.service-now.com/',
  midserver_java_heap_max => undef,
  midserver_max_threads   => undef,
}
*/

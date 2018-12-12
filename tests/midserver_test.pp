

class prep {
  notify { "Running prep on: ${hostname}": }
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
    midserver_home          => 'c:/ServiceNow',
    xml_fragments           => lookup('servicenow_midserver::xml_fragments'),
  }
}

class test {

  notify { "Running test on: ${hostname}": }
  Exec { provider => powershell, logoutput => true }

  exec { 'Check choco version is: 1.6.1':
    command => 'if ($(choco -v) -eq "1.6.1") {exit 0} else {exit 1}',
  }

  exec { 'Check service state is: running': 
    command => 'if ($(Get-Service -Name snc_mid).status -eq "Running") {exit 0} else {exit 1}',
  }

}


Class{'prep': noop => true}
Class{'test': require => Class['prep']}

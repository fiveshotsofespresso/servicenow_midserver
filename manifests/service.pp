# Class: servicenow_midserver::service:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::service {

  if $facts['os']['family'] == 'Windows'{
    exec {'Initiate ServiceNow Midserver':
      command  => 'cmd.exe /c .\start.bat',
      cwd      => "${servicenow_midserver::midserver_install_dir}${servicenow_midserver::midserver_name}/agent",
      unless   => 'if(Get-Service snc_mid) { exit 0 } else { exit 1 }',
      provider => 'powershell',
    }
  } else {
    exec {'Initiate ServiceNow Midserver':
      command => '.\start.sh',
      cwd     => "${servicenow_midserver::midserver_install_dir}${servicenow_midserver::midserver_name}/agent/bin",
      path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin:/opt/local/bin',
      unless  => 'service snc_mid status'
    }
  }

  service{'snc_mid':
    ensure => running
  }

}

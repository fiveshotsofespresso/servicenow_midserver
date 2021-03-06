# Class: servicenow_midserver::service:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::service {

  exec {'Initiate ServiceNow Midserver':
    command  => 'cmd.exe /c .\start.bat',
    cwd      => "${servicenow_midserver::root_drive}/ServiceNow/agent",
    unless   => 'if(Get-Service snc_mid) { exit 0 } else { exit 1 }',
    provider => 'powershell',
  }

  service{'snc_mid':
    ensure => running
  }

}

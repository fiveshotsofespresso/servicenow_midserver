# Class: servicenow_midserver::install:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::install {

  exec {'Initiate ServiceNow Midserver':
    command  => 'cmd.exe /c .\start.bat',
    cwd      => "${servicenow_midserver::root_drive}/ServiceNow/agent",
    unless   => 'if(Get-Service snc_mid) { exit 0 } else { exit 1 }',
    provider => 'powershell',
  }

}

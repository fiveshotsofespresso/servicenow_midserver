# Class: servicenow_midserver::download:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::install {

  include ::archive

  $midserver_home = "${servicenow_midserver::root_drive}/ServiceNow"

  file{ $midserver_home:
    ensure => directory
  }

  archive{'ServiceNow Midserver Zip':
    ensure         => present,
    path           => "${servicenow_midserver::root_drive}/temp/agent.zip",
    extract        => true,
    source         => $servicenow_midserver::midserver_source,
    extract_path   => $midserver_home,
    creates        => "${midserver_home}/agent",
    cleanup        => true,
    allow_insecure => true,
    require        => File[$midserver_home],
  }

}

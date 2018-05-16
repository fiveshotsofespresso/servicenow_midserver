# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include servicenow_midserver::download
class servicenow_midserver::download {

  include ::archive

  $midserver_home = "${servicenow_midserver::root_drive}/ServiceNow"

  file{ $servicenow_midserver::midserver_home:
    ensure => directory
  }

  archive{'ServiceNow Midserver Zip':
    ensure         => present,
    path           => "${servicenow_midserver::root_drive}/temp/agent.zip",
    extract        => true,
    source         => $servicenow_midserver::midserver_source,
    extract_path   => $servicenow_midserver::midserver_home,
    creates        => "${servicenow_midserver::midserver_home}/agent",
    cleanup        => true,
    allow_insecure => true,
    require        => File["${servicenow_midserver::midserver_home}"],
  }

}

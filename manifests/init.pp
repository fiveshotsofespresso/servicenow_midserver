# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include servicenow_midserver
class servicenow_midserver (
  String $source                   = undef,
  String $servicenow_username      = undef,
  String $servicenow_password      = undef,
  String $drive                    = 'C:/',
  String $midserver_name           = ::facts['hostname'],
  Optional[Integer] $java_heap_max = undef,
  Optional[Integer] $max_threads   = undef,
  Optional[String] $proxy_host     = undef,
  Optional[String] $proxy_port     = undef,
  Optional[String] $proxy_username = undef,
  Optional[String] $proxy_password = undef,
) {

  include ::archive
	$midserver_home = "${drive}/ServiceNow"

  file{$midserver_home:
    ensure => directory
  }

  archive{'ServiceNow Midserver Zip':
    ensure         => present,
    path           => "${drive}/temp/agent.zip",
    extract        => true,
    source         => $source,
    extract_path   => "${midserver_home}":,
    creates        => "${midserver_home}/agent",
    cleanup        => true,
    allow_insecure => true,
    require        => File["${midserver_home"],
    notify         => Service['snc_mid']
  }

  class{'::servicenow_midserver::config':}
  -> class{'::servicenow_midserver::install':}
  ~> class{'::servicenow_midserver::service':}
}

# Class: servicenow_midserver  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver (
  Optional[String] $package_source,
  String $package_name,
  String $package_version,
  String $service_name = 'snc_mid',
  String $service_display_name = 'snc_mid',
  String $chocolatey_source = 'c:/windows/temp/chocolateysource',
  String $midserver_name,
  String $midserver_home,
  String $servicenow_url,
  String $servicenow_username,
  String $servicenow_password,
  Optional[Integer] $midserver_java_heap_max = undef,
  Optional[Integer] $midserver_max_threads   = undef
) {

  contain servicenow_midserver::install
  contain servicenow_midserver::config
  contain servicenow_midserver::service

  Class['::servicenow_midserver::install']
  -> Class['::servicenow_midserver::config']
  ~> Class['::servicenow_midserver::service']
}

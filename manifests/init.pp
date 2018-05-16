# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include servicenow_midserver
class servicenow_midserver (
  String $midserver_source,
  String $midserver_name,
  Optional[Integer] $midserver_java_heap_max,
  Optional[Integer] $midserver_max_threads,
  String $root_drive,
  String $servicenow_username,
  String $servicenow_password,
  Optional[String] $proxy_host,
  Optional[String] $proxy_port,
  Optional[String] $proxy_username,
  Optional[String] $proxy_password,
) {

  contain servicenow_midserver::download
  contain servicenow_midserver::config
  contain servicenow_midserver::install
  contain servicenow_midserver::service

  Class['::servicenow_midserver::download']
  -> Class['::servicenow_midserver::config']
  -> Class['::servicenow_midserver::install']
  ~> Class['::servicenow_midserver::service']
}

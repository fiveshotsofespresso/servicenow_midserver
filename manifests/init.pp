# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include servicenow_midserver
class servicenow_midserver (
  String $midserver_source,
  String $midserver_name,
  String $root_drive,
  String $servicenow_url,
  String $servicenow_username,
  String $servicenow_password,
  Optional[Integer] $midserver_java_heap_max = undef,
  Optional[Integer] $midserver_max_threads   = undef
) {

  contain servicenow_midserver::download
  contain servicenow_midserver::config
  contain servicenow_midserver::install
  contain servicenow_midserver::service

  Class['::servicenow_midserver::download']
  -> Class['::servicenow_midserver::config']
  -> Class['::servicenow_midserver::install']
  -> Class{'::servicenow_midserver::service':
    subscribe => Class['::servicenow_midserver::config']
  }
}

# Class: servicenow_midserver::download:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::install {

  include ::archive
 
  if $servicenow_midserver::package_source {
    $package_version = 'installed'
    file {  "${servicenow_midserver::chocolatey_source}/${servicenow_midserver::package_name}-${servicenow_midserver::package_version}.nupkg":
      ensure  => present,
      source  => $servicenow_midserver::package_source,
      before  => Package[$servicenow_midserver::package_name]
     }
  } else {
    $package_version = $servicenow_midserver::package_version 
  }

  $install_options = sprintf('--params " /installPath:""%s"" /name:""%s"" /displayName:""%s"" "',
    $servicenow_midserver::midserver_home,
    $servicenow_midserver::service_name,
    $servicenow_midserver::service_display_name).split(' ')

  package { $servicenow_midserver::package_name:
    ensure          => $package_version,
    provider        => chocolatey,
    install_options => $install_options,
  }
}

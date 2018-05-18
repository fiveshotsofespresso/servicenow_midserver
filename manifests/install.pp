# Class: servicenow_midserver::download:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::install {

  include ::archive

  file{ $servicenow_midserver::midserver_install_dir:
    ensure => directory
  }

  archive{'ServiceNow Midserver Zip':
    ensure         => present,
    path           => "${servicenow_midserver::midserver_install_dir}agent.zip",
    extract        => true,
    source         => $servicenow_midserver::midserver_source,
    extract_path   => $servicenow_midserver::midserver_install_dir,
    creates        => "${servicenow_midserver::midserver_install_dir}${servicenow_midserver::midserver_name}/agent",
    cleanup        => true,
    allow_insecure => true,
    require        => File[$servicenow_midserver::midserver_install_dir],
  }

}

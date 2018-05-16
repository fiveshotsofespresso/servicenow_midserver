# Class: servicenow_midserver::config:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::config {

  # The following xml_fragment resources manipulate the config.xml file. 
  # [Future Enhancement] If Augeas ever becomes available for Windows...

  $config_home = "${servicenow_midserver::root_drive}/ServiceNow/agent"

  xml_fragment { 'ServiceNow Instance URL':
    ensure  => 'present',
    path    => "${config_home}/config.xml",
    xpath   => "/parameters/parameter[@name='url']",
    content => {
      attributes => {
        'value' => $servicenow_midserver::servicenow_url,
      },
    },
  }

  xml_fragment { 'ServiceNow Midserver Username':
    ensure  => 'present',
    path    => "${config_home}/config.xml",
    xpath   => "/parameters/parameter[@name='mid.instance.username']",
    content => {
      attributes => {
        'value' => $servicenow_midserver::servicenow_username,
      },
    },
  }

  # We can't allow encryption of the password on the MID Server itself or the file will be changed every run, restarting the MID midserver
  # Password is encrypted Puppet side using EYAML

  xml_fragment { 'ServiceNow Midserver Password':
    ensure  => 'present',
    path    => "${config_home}/config.xml",
    xpath   => "/parameters/parameter[@name='mid.instance.password']",
    content => {
      attributes => {
        'value'  => $servicenow_midserver::servicenow_password,
        'secure' => 'false' # lint:ignore:quoted_booleans
        'encrypt' => 'false' # lint:ignore:quoted_booleans
      },
    },
  }

  xml_fragment { 'ServiceNow Midserver Name':
    ensure  => 'present',
    path    => "${config_home}/config.xml",
    xpath   => "/parameters/parameter[@name='name']",
    content => {
      attributes => {
        'value' => $servicenow_midserver::midserver_name,
      },
    },
  }

  file_line { 'Set Java heap max':
    ensure => present,
    path   => "${config_home}/conf/wrapper-override.conf",
    line   => "wrapper.java.maxmemory=${servicenow_midserver::midserver_java_heap_max}",
  }
}

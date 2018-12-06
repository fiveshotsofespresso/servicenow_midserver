# Class: servicenow_midserver::config:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::config {

  # The following xml_fragment resources manipulate the config.xml file. 
  # [Future Enhancement] If Augeas ever becomes available for Windows...

  Xml_fragment {
    ensure => present,
    path    => "${servicenow_midserver::midserver_home}/config.xml",
  }

  xml_fragment { 'ServiceNow Instance URL':
    xpath   => "/parameters/parameter[@name='url']",
    content => {
      attributes => {
        'value' => $servicenow_midserver::servicenow_url,
      },
    },
  }

  xml_fragment { 'ServiceNow Midserver Username':
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
    xpath   => "/parameters/parameter[@name='mid.instance.password']",
    content => {
      attributes => {
        'value'   => $servicenow_midserver::servicenow_password,
        'secure'  => 'false', # lint:ignore:quoted_booleans
        'encrypt' => 'true' # lint:ignore:quoted_booleans
      }
    },
    noop => $noop_password
  }

  xml_fragment { 'ServiceNow Midserver Name':
    xpath   => "/parameters/parameter[@name='name']",
    content => {
      attributes => {
        'value' => $servicenow_midserver::midserver_name,
      },
    },
  }


}

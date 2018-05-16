# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#   include servicenow_midserver::service
class servicenow_midserver::service {
  service{'snc_mid':
    ensure => running
  }
}

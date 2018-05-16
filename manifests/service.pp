# Class: servicenow_midserver::service:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::service {
  service{'snc_mid':
    ensure => running
  }
}

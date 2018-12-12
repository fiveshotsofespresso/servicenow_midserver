# Class: servicenow_midserver::config:  See README.md for documentation.
# ===========================
#
#
class servicenow_midserver::config (
  Hash $xml_fragments = $servicenow_midserver::xml_fragments,
  String $midserver_home = $servicenow_midserver::midserver_home
) {
  # The following xml_fragment resources manipulate the config.xml file. 
  # [Future Enhancement] If Augeas ever becomes available for Windows...

  $xml_fragment_defaults = {
    ensure => present,
    path   => "${midserver_home}/config.xml",
  }

  $xml_fragments.each |String $xml_fragment, Hash $attributes| {
    Resource['xml_fragment'] {
      $xml_fragment: * => $attributes;
      default:  * => $xml_fragment_defaults;
    }
  }
}

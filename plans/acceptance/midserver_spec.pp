# Example usage:
# pdk bundle exec rake spec_prep
# bolt plan run servicenow_midserver::acceptance::service_spec --modulepath ./spec/fixtures/modules  --no-ssl 
# 
# OR from PDK:
# pdk bundle exec rake acceptance

plan servicenow_midserver::acceptance::midserver_spec (
  Optional[String[3]] $workspace_dir = '/tmp',
) {

  # Create the target test vm using the helper
  $target = run_plan('servicenow_midserver::acceptance::acceptance_helper', 'workspace_dir' => $workspace_dir, 'task' => 'create_target')

  # Execute tests:
  apply_prep($target)
  add_facts($target, { 'archive_windir' => 'c:\\staging' })
  $apply_results = apply($target,'_catch_errors' => true) { 
    class {'chocolatey':
      chocolatey_download_url         => 'https://som2.som.nats.co.uk/som4dml/data/DML000085/chocolatey.0.10.11.nupkg',
      use_7zip                        => false,
      choco_install_timeout_seconds   => 2700,
    }
    $chocolateysource = 'c:/windows/temp/chocolateysource'
    file { $chocolateysource: ensure => directory, before => Chocolateysource['local'] }
    chocolateysource {'local':
      ensure   => present,
      require  => Class['chocolatey'],
      location => $chocolateysource,
      before   => Class['servicenow_midserver'],
    }
    class { 'servicenow_midserver':
      package_name            => 'servicenow-midserver-kingston',
      package_version         => '1.6.1',
      package_source          => 'https://som2.som.nats.co.uk/som4dml/data/DML000084/servicenow-midserver-kingston.1.6.1.nupkg',
      midserver_home          => 'c:/ServiceNow',
      xml_fragments           => lookup('servicenow_midserver::xml_fragments'),
    }
  }
  $results = run_task('servicenow_midserver::acceptance_service_status', $target, '_catch_errors' => true , 'service_name' => 'snc_mid' )
 
  # Destroy the target test vm using the helper
  #run_plan('servicenow_midserver::acceptance::acceptance_helper', 'workspace_dir' => $workspace_dir, 'task' => 'destroy_target')
  unless $apply_results.ok {
    fail($apply_results.first.error)
  }
  return  $results
}

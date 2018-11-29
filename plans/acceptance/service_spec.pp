# Example usage:
# pdk bundle exec rake spec_prep
# bolt plan run servicenow_midserver::acceptance::service_spec --modulepath ./spec/fixtures/modules  --no-ssl  

plan servicenow_midserver::acceptance::service_spec (
  Optional[String[3]] $workspace_dir = '/tmp',
) {

  # Create the target test vm using the helper
  $target = run_plan('servicenow_midserver::acceptance::acceptance_helper', 'workspace_dir' => $workspace_dir, 'task' => 'create_target')

  # Execute tests:
  apply_prep($target)
  add_facts($target, { 'archive_windir' => 'c:\\staging' })
  apply($target,'_catch_errors' => true) { 
    class { 'servicenow_midserver':
      midserver_source        => 'https://install.service-now.com/glide/distribution/builds/package/mid/2018/03/19/mid.istanbul-09-23-2016__patch11a-03-13-2018_03-19-2018_0958.windows.x86-64.zip',
      midserver_name          => 'Discovery_MID1',
      root_drive              => 'c:',
      servicenow_username     => 'foo',
      servicenow_password     => 'bar',
      servicenow_url          => 'https://myinstance.service-now.com/',
      midserver_java_heap_max => undef,
      midserver_max_threads   => undef,
    }
  }
  $results = run_task('servicenow_midserver::acceptance_service_status', $target, '_catch_errors' => true , 'service_name' => 'snc_mid' )
 
  # Destroy the target test vm using the helper
  run_plan('servicenow_midserver::acceptance::acceptance_helper', 'workspace_dir' => $workspace_dir, 'task' => 'destroy_target')

  return $results
}

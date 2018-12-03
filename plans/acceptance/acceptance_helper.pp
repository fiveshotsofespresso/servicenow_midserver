# Helper for use with acceptance test plans
# Usage:
# To get the target created as part of an acceptance test, add the following like to your acceptance test plan:
# $target = run_plan('<module_name>::acceptance::acceptance_helper', 'workspace_dir' => '/tmp', 'task' => 'create_target')


plan servicenow_midserver::acceptance::acceptance_helper (
  Enum['create_target','destroy_target']$task,
  String[3] $workspace_dir,                         # execute from the root of this module, param to pass to bolt plan: workspace=`pwd`
  Optional[String[1]] $vagrant_target            = 'testvm',
  Optional[String[7]] $vagrant_target_ip         = '10.10.10.10',
  Optional[String[3]] $vagrant_target_hostname   = 'testvm',
  Optional[String[3]] $vagrant_target_modulepath = '/tmp/${title}',
  Optional[String[1]] $puppet_agent_version      = '5.5.6',
  Optional[String[1]] $puppet_master_server      = 'puppet',
  Optional[String[1]] $vagrant_synced_folder     = 'c:\\vagrant',
  Optional[Boltlib::TargetSpec] $controller      = get_targets('localhost')[0],
  String $puppet_agent_msi_url                   = "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-${puppet_agent_version}-x64.msi",
  String $puppet_agent_msi_src                   = "c:\\Windows\\Temp\\puppet-agent-${puppet_agent_version}-x64.msi",
) {

  $vagrant_workspace_dir = "${workspace_dir}/puppet_acceptance"
  
  case $task {
    'create_target': {
      $install_pe_agent_win = [
          "(New-Object System.Net.WebClient).DownloadFile(\'${puppet_agent_msi_url}\', \'${puppet_agent_msi_src}\')",
          "; \$PROC = [System.Diagnostics.Process]::Start(\'C:\\Windows\\System32\\msiexec.exe\', \'/qn /i ",
          "${puppet_agent_msi_src} PUPPET_MASTER_SERVER=${puppet_master_server} PUPPET_AGENT_STARTUP_MODE=disabled\') ; \$PROC.WaitForExit()",
      ].join('')
      apply($controller) { 
        file { "${vagrant_workspace_dir}": ensure => directory, purge => true } 
        file { "${vagrant_workspace_dir}/Vagrantfile": 
          content => @("EOF")
            Vagrant.configure("2") do |config| 
              config.vm.define :${vagrant_target} do |node|
                node.vm.provider "virtualbox" do |vb|
                  vb.memory = "4096"
	                vb.cpus = "2"
                end
                node.vm.box              = "opentable/win-2012r2-standard-amd64-nocm"
                node.vm.box_check_update = false
                node.vm.hostname         = '${vagrant_target_hostname}'
                node.vm.network :private_network, :ip => '${vagrant_target_ip}'
                node.vm.guest = :windows
                node.vm.communicator = "winrm"
              end
            end
          | EOF
        }
      }
      run_command("cd ${vagrant_workspace_dir} ; vagrant up ${vagrant_target}", $controller, '_catch_errors' => true)
      $target = get_targets("winrm://vagrant:vagrant@${vagrant_target_ip}")[0]
      run_command("${install_pe_agent_win}", $target, '_catch_errors' => true)
      return $target
    }

    'destroy_target': {
      run_command("cd ${vagrant_workspace_dir} j vagrant destroy -f ${vagrant_target}", $controller, '_catch_errors' => true)
    }
  }
}

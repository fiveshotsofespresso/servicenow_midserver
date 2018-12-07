# Helper for use with puppet apply
# Usage:
# puppet apply (on the controller node that runs the test)

  $workspace_dir   ='c:\tmp'                      # execute from the root of this module, param to pass to bolt plan: workspace=`pwd`
  $vagrant_target            = 'testvm'
  $vagrant_target_ip         = '10.10.10.10'
  $vagrant_target_hostname   = 'testvm'
  $puppet_agent_version      = '5.5.6'
  $puppet_master_server      = 'puppet'
  $puppet_agent_msi_url      = "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-${puppet_agent_version}-x64.msi"
  $puppet_agent_msi_src      = "c:\\Windows\\Temp\\puppet-agent-${puppet_agent_version}-x64.msi"
  $vagrant_workspace_dir     = "${workspace_dir}/puppet_acceptance_${}"
  $vagrant_path              = 'C:/HashiCorp/Vagrant/bin'
  $vagrantfile               = "${vagrant_workspace_dir}/Vagrantfile"

  case $action {
    'create_vm': {
      $install_pe_agent_win = [
          "(New-Object System.Net.WebClient).DownloadFile(\'${puppet_agent_msi_url}\', \'${puppet_agent_msi_src}\')",
          "; \$PROC = [System.Diagnostics.Process]::Start(\'C:\\Windows\\System32\\msiexec.exe\', \'/qn /i ",
          "${puppet_agent_msi_src} PUPPET_MASTER_SERVER=${puppet_master_server} PUPPET_AGENT_STARTUP_MODE=disabled\') ; \$PROC.WaitForExit()",
      ].join('')
 
      file { "${vagrant_workspace_dir}": ensure => directory, purge => true } 
      file { $vagrantfile: 
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
              node.vm.provision "shell", inline: "Set-Item WSMan:\\localhost\\Shell\\MaxMemoryPerShellMB 2048"
              node.vm.provision "shell", inline: "Start-PSJob \'sleep 1 ; Get-Service WinRM | Restart-Service -Force\'"
              node.vm.provision "shell", inline: "${install_pe_agent_win}"
            end
          end
          | EOF
       }
   
    exec {"vagrant up ${vagrant_target}":
	    cwd     => "${vagrant_workspace_dir}",
		  noop    => true,
		  path    => $vagrant_path,
		  require => File[$vagrantfile],
	  }
    
  }
	
	'destroy_vm': {
	  exec {"vagrant destroy -f ${vagrant_target}":
	    cwd  => "${vagrant_workspace_dir}",
		noop => true,
		path => $vagrant_path,
        require => File[$vagrantfile],
	  }
	}
  }

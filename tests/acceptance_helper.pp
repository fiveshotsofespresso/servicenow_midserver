# Helper for use with puppet apply
# Usage:
# puppet apply (on the controller node that runs the test)
  case $facts['kernel'] {
    'windows': { 
      $rootdrive        = 'c:'
      $vagrant_bin_path = 'C:/HashiCorp/Vagrant/bin'
    }
    default: { 
      $rootdrive        = "" 
      $vagrant_bin_path = '/usr/local/bin'
    }
  }
  $workspace_dir             ="${rootdrive}/tmp" 
  $vagrant_target            = 'testvm'
  $vagrant_target_ip         = '10.10.10.10'
  $vagrant_target_hostname   = 'testvm'
  $puppet_agent_version      = '5.5.6'
  $puppet_master_server      = 'puppet'
  $puppet_agent_msi_url      = "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-${puppet_agent_version}-x64.msi"
  $puppet_agent_msi_src      = "c:\\vagrant\\puppet_agent_installer.msi"
  $vagrant_workspace_dir     = "${workspace_dir}/puppet_acceptance"
  $vagrantfile               = "${vagrant_workspace_dir}/Vagrantfile"

  $install_pe_agent_win = [
      "\$PROC = [System.Diagnostics.Process]::Start(\'C:\\Windows\\System32\\msiexec.exe\', \'/qn /i ",
      "${puppet_agent_msi_src} PUPPET_MASTER_SERVER=${puppet_master_server} PUPPET_AGENT_STARTUP_MODE=disabled\') ; \$PROC.WaitForExit()",
  ].join('')
  file { "${vagrant_workspace_dir}": ensure => directory } 
  file { "${vagrant_workspace_dir}/puppet_agent_installer.msi": ensure => file, source => $puppet_agent_msi_url }
  file { $vagrantfile: 
    ensure  => file,
    content => @("EOF")
      Vagrant.configure("2") do |config| 
        config.vm.define :${vagrant_target} do |node|
          node.vm.provider "virtualbox" do |vb|
            vb.memory = "4096"
            vb.cpus   = "2"
          end
          node.vm.box                           = "opentable/win-2012r2-standard-amd64-nocm"
          node.vm.box_check_update              = false
          node.vm.hostname                      = '${vagrant_target_hostname}'
          node.vm.network :private_network, :ip => '${vagrant_target_ip}'
          node.vm.guest                         = :windows
          node.vm.synced_folder "${modulepath}/../.", "C:/ProgramData/Puppetlabs/code/environments/production/"
          node.vm.communicator                  = "winrm"
          node.vm.provision "shell", inline: "Set-Item WSMan:\\localhost\\Shell\\MaxMemoryPerShellMB 2048"
          node.vm.provision "shell", inline: "Start-PSJob \'sleep 1 ; Get-Service WinRM | Restart-Service -Force\'"
          node.vm.provision "shell", inline: "${install_pe_agent_win}"
        end
      end
      | EOF
  }

  case $action {
    'create_vm': {
      exec {"vagrant up ${vagrant_target}":
	      cwd     => "${vagrant_workspace_dir}",
		    path    => $vagrant_bin_path,
		    require => File[$vagrantfile],
	    }
    }
	
	  'destroy_vm': {
	    exec {"vagrant destroy -f ${vagrant_target}":
	      cwd  => "${vagrant_workspace_dir}",
	    	path => $vagrant_bin_path,
        require => File[$vagrantfile],
        noop => true,
	    }
  	}
  }

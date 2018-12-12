# Helper for use with puppet apply
# Usage:
# puppet apply (on the controller node that runs the test)
# Pre-reqs:
# The following facts must be set upon 'puppet apply' to sync fixtures to the target vagrant
# FACTER_cwd ($cwd) - the root of the module
# FACTER_test ($test) - the manifest to apply

  ### Controller Parameters
  case $facts['kernel'] {
    'windows': { 
      $rootdrive                  = 'c:'
      $vagrant_bin_path           = 'C:/HashiCorp/Vagrant/bin'
    }
    default: { 
      $rootdrive        = "" 
      $vagrant_bin_path = '/usr/local/bin'
    }
  }
  $vagrantfile               = "${cwd}/Vagrantfile"
  ###

  ### Target-specifc Parameters
  # - Currently supported operating systems (boxes) include: windows - TODO: move this to nodesets style pattern
  $puppet_agent_version       = '5.5.6'
  $puppet_agent_installer_url = "https://downloads.puppetlabs.com/windows/puppet5/puppet-agent-${puppet_agent_version}-x64.msi"
  $guest_dir                  = "c:\\\\vagrant"
  $vagrant_target             = 'testvm'
  $vagrant_target_ip          = '10.10.10.10'
  $vagrant_target_hostname    = 'testvm'
  $puppet_master_server       = 'puppet'
  $guest_puppet_dir           = "C:/ProgramData/Puppetlabs"
  $guest_code_dir             = "${guest_puppet_dir}/code/environments/production"
  $puppet_agent_installer_src = "C:\\\\tmp\\\\puppet_agent_installer.msi"
  $agent_install_args         = "PUPPET_MASTER_SERVER=${puppet_master_server} PUPPET_AGENT_STARTUP_MODE=disabled"
  $prep_scripts = [
    # Install puppet agent
    "\$PROC = [System.Diagnostics.Process]::Start(\'C:\\\\Windows\\\\System32\\\\msiexec.exe\', \'/qn /i ${puppet_agent_installer_src} $agent_install_args\')",
    "\$PROC.WaitForExit()",
    # Purge the code dir
    "rm -Force \'${guest_code_dir}/*\'",
  ].join(' ; ')
  ###
  

  file { "${cwd}/spec/fixtures/files": ensure => directory }
  file { "${cwd}/spec/fixtures/files/puppet_agent_installer.msi": ensure => file, source => $puppet_agent_installer_url }
  file { $vagrantfile: # TODO: move this to nodesets style pattern
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
          node.vm.synced_folder ".", "/vagrant", disabled: true
          node.vm.provision "file", source: "${cwd}/spec/fixtures/files/puppet_agent_installer.msi", destination: "${puppet_agent_installer_src}"
          node.vm.provision "shell", inline: "${prep_scripts}"
          node.vm.provision "file", source: "${cwd}/spec/fixtures/modules/.", destination: "${guest_code_dir}/modules"
          node.vm.provision "file", source: "${cwd}", destination: "${guest_code_dir}/modules/"
          node.vm.provision "test", type: "shell", inline: "puppet apply \'${guest_code_dir}/modules/${test}\'", run: "never"
        end
      end
      | EOF
  }

  case $action {
    'create_vm': {
      exec {"vagrant up ${vagrant_target} --provision":
	      cwd       => "${cwd}",
		    path      => $vagrant_bin_path,
		    require   => File[$vagrantfile],
        timeout   => 1200,
        logoutput => true,
	    }
    }
    'test': {
      exec {"vagrant up ${vagrant_target} --provision-with test":
	      cwd       => "${cwd}",
		    path      => $vagrant_bin_path,
		    require   => File[$vagrantfile],
        timeout   => 1200,
        logoutput => true,
	    }
    }
	  'destroy_vm': {
	    exec {"vagrant destroy -f ${vagrant_target}":
	      cwd     => "${cwd}",
	    	path    => $vagrant_bin_path,
        require => File[$vagrantfile],
	    }
  	}
  }

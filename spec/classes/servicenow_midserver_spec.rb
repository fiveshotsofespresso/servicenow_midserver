require 'spec_helper'

describe 'servicenow_midserver' do
  
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:params) { 
        {
          'midserver_source'         => 'https://packages.localhost/servicenow/mid_server/agent.zip',
          'midserver_name'           => 'midserver99',
          'midserver_home'           => 'c:/ServiceNow',
          'servicenow_url'           => 'https://midserver_instance.local',
          'servicenow_username'      => 'user',
          'servicenow_password'      => 'pass',
        }
      }
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
    end
  end
end


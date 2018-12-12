require 'spec_helper'

describe 'servicenow_midserver' do
  
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:params) { 
        {
          'package_source'         => 'https://packages.localhost/servicenow/mid_server/agent.zip',
          'package_name'           => 'servicenow-midserver-kingston',
          'package_version'        => '1.6.1',
          'midserver_home'         => 'c:/ServiceNow',
          'xml_fragments'          => {},
        }
      }
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to compile.with_all_deps }
    end
  end
end




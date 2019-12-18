require 'spec_helper'

describe 'service_definitions' do
  let(:params) do
    {
      services: {
        'testtcp' => {
          'port' => 65001,
          'protocols' => ['tcp']
        },
        'testudp' => {
          'port' => 65002,
          'protocols' => ['udp']
        },
        'testddp' => {
          'port' => 65003,
          'protocols' => ['ddp']
        },
        'testudptcp' => {
          'port' => 65004,
          'protocols' => ['udp', 'tcp']
        },
        'testdescr' => {
          'port' => 65005,
          'protocols' => ['udp', 'tcp'],
          'description' => 'test decsription'
        },
        'testalias1' => {
          'port' => 65006,
          'protocols' => ['udp', 'tcp'],
          'aliases' => ['test1']
        },
        'testalias2' => {
          'port' => 65007,
          'protocols' => ['udp', 'tcp'],
          'aliases' => ['test1', 'test2']
        },
        'testall' => {
          'port' => 65008,
          'protocols' => ['udp', 'tcp'],
          'aliases' => ['test1', 'test2'],
          'description' => 'test decsription all'
        }
      }
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      context 'with default params' do
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end

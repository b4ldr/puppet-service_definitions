# frozen_string_literal: true

require 'spec_helper'

describe 'service_definitions' do
  let(:params) do
    {
      services: {
        'testtcp' => {
          'port' => 65_001,
          'protocols' => ['tcp'],
        },
        'testudp' => {
          'port' => 65_002,
          'protocols' => ['udp'],
        },
        'testddp' => {
          'port' => 65_003,
          'protocols' => ['ddp'],
        },
        'testudptcp' => {
          'port' => 65_004,
          'protocols' => ['udp', 'tcp'],
        },
        'testdescr' => {
          'port' => 65_005,
          'protocols' => ['udp', 'tcp'],
          'description' => 'test decsription',
        },
        'testalias1' => {
          'port' => 65_006,
          'protocols' => ['udp', 'tcp'],
          'aliases' => ['test1'],
        },
        'testalias2' => {
          'port' => 65_007,
          'protocols' => ['udp', 'tcp'],
          'aliases' => ['test1', 'test2'],
        },
        'testall' => {
          'port' => 65_008,
          'protocols' => ['udp', 'tcp'],
          'aliases' => ['test1', 'test2'],
          'description' => 'test decsription all',
        },
      },
    }
  end

  on_supported_os.each do |os, _facts|
    context "on #{os}" do
      context 'with default params' do
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end

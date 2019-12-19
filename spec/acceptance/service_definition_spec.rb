# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'service_definition resource' do
  describe 'install services' do
    it 'work with no errors' do
      pp = <<~MANIFEST
      service_definition{'test':
          port        => 65000,
          protocols   => ['udp','tcp'],
          description => 'testing',
          aliases     => ['alias1','alias2']
      }
      service_definition{'testudp':
          port      => 65001,
          protocols => ['udp'],
      }
      service_definition{'testtcp':
          port      => 65002,
          protocols => ['tcp'],
      }
      service_definition{'testddp':
          port      => 65003,
          protocols => ['ddp'],
      }
      service_definition{'testalias':
          port      => 65004,
          protocols => ['udp'],
          aliases   => ['foobar'],
      }
      service_definition{'testdescr':
          port        => 65005,
          protocols   => ['tcp'],
          description => 'foobar',
      }
      MANIFEST
      apply_manifest(pp, catch_failures: true)
      expect(apply_manifest(pp, catch_failures: true).exit_code).to eq 0
    end
    [
      '^test\s+65000/tcp\s+alias1 alias2\s+# testing$',
      '^test\s+65000/udp\s+alias1 alias2\s+# testing$',
      '^testudp\s+65001/udp$',
      '^testtcp\s+65002/tcp$',
      '^testddp\s+65003/ddp$',
      '^testalias\s+65004/udp\s+foobar$',
      '^testdescr\s+65005/tcp\s+# foobar$'
    ].each do |pattern|
      describe command("grep -cE '#{pattern}' /etc/services") do
        its(:exit_status) { is_expected.to eq 0 }
        its(:stdout) { is_expected.to eq "1\n" }
      end
    end
  end
  describe 'remove services' do
    it 'run puppet' do
      pp = <<~MANIFEST
      service_definition{['test', 'testudp', 'testtcp', 'testddp', 'testalias', 'testdescr']:
        ensure => absent,
      }
      MANIFEST
      apply_manifest(pp, catch_failures: true)
      expect(apply_manifest(pp, catch_failures: true).exit_code).to eq 0
    end
    [
      '^test\s', '^testudp\s', '^testtcp\s',
      '^testddp\s', '^testalias\s', '^testdescr\s'
    ].each do |pattern|
      describe command("grep -cE '#{pattern}' /etc/services") do
        its(:exit_status) { is_expected.to eq 1 }
        its(:stdout) { is_expected.to eq "0\n" }
      end
    end
  end
end

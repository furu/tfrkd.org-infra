require 'spec_helper'

describe 'nginx' do
  describe package('nginx') do
    it { should be_installed }
  end

  describe service('nginx') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe file('/etc/nginx/sites-enabled/default') do
    it { should exist }
  end

  describe file('/etc/nginx/sites-enabled/nakiroku') do
    it { should exist }
  end
end

describe 'sshd' do
  describe package('openssh-server') do
    it { should be_installed }
  end

  describe service('ssh') do
    it { should be_enabled }
    it { should be_running }
  end

  describe port(22) do
    it { should be_listening }
  end

  describe file('/etc/ssh/sshd_config') do
    its(:content) { should match(/^PermitRootLogin no/) }
    its(:content) { should match(/^PasswordAuthentication no/) }
    its(:content) { should match(/^PermitEmptyPasswords no/) }
  end
end

describe 'supervisor' do
  describe package('supervisor') do
    it { should be_installed }
  end

  describe service('supervisor') do
    # it { should be_enabled }
    it { should be_running }
  end

  describe file('/etc/supervisor/conf.d/tfrkd.org.conf') do
    it { should exist }
  end
end

describe 'logwatch' do
  describe package('logwatch') do
    it { should be_installed }
  end

  describe file('/etc/logwatch/conf/logwatch.conf') do
    it { should exist }
  end

  describe file('/etc/cron.daily/00logwatch') do
    it { should exist }
  end

  describe service('exim4') do
    # it { should be_enabled }
    it { should be_running }
  end
end

describe 'misc' do
  describe cron do
    let(:nakiroku_cron_entry) do
      '1 * * * * cd /home/furu/www/nakiroku && ruby nakiroku.rb'
    end
    it { should have_entry(nakiroku_cron_entry).with_user('furu') }
  end

  describe user('furu') do
    it { should exist }
    it { should belong_to_group 'sudo' }
  end

  describe user('circleci') do
    it { should exist }
  end

  describe package('ruby') do
    it { should be_installed }
  end

  describe package('sudo') do
    it { should be_installed }
  end

  describe file('/etc/sudoers') do
    its(:content) do
      should match(%r|circleci ALL=\(ALL:ALL\) NOPASSWD: /usr/bin/supervisorctl|)
    end
  end
end

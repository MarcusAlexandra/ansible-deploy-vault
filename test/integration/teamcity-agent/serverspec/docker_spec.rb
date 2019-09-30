require 'spec_helper'

describe package ('docker') do
  it { should be_installed.with_version('1.13.1') }
  describe service('docker') do
    it { should be_enabled }
    it { should be_running }
  end
end

# describe package ('container-selinux') do
#   it { should be_installed.with_version('1.13.1') }
#   describe service('docker') do
#     it { should be_enabled }
#     it { should be_running }
#   end
# end

%w(/etc/docker
).each do |dockerdir|
  describe file "#{dockerdir}", :if => os[:arch] == 'x86_64' do
    it { should exist }
    it { should be_directory }
  end
end

# %w(python2-pip
#    python-devel
#    sysstat
#    bind-utils
#    rsyslog
#    epel-release
#    container-selinux
#   ).each do |pkg|
#    describe package "#{pkg}" do
#      it { should be_installed }
#      end
#   end

# %w(/etc/rsyslog.d/docker.conf
#
#    /usr/local/sbin/docker-clean
#    /etc/cron.d/dockerclean
#    /etc/docker/daemon.json
#   ).each do |pubkey|
#       describe file "#{pubkey}", :if => os[:arch] == 'x86_64' do
#         it { should exist }
#         it { should be_file }
#       end
#     end

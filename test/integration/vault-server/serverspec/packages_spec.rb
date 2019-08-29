require 'spec_helper'

describe yumrepo('epel') do
  it { should exist }
  it { should be_enabled }
end

%w(git
  openssh-clients
  openssl-devel
  rsync
  sysstat
  sudo
  tar
  unzip
  wget
  zip
  ).each do |pkg|
   describe package "#{pkg}", :if => os[:arch] == 'x86_64' do
     it { should be_installed }
     end
  end

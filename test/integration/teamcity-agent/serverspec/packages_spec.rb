require 'spec_helper'

describe yumrepo('epel') do
  it { should exist }
  it { should be_enabled }
end

%w(bzip2
  fontconfig
  freetype
  gcc
  git
  java-1.8.0-openjdk-1.8.0.161
  java-1.8.0-openjdk-devel-1.8.0.161
  openssh-clients
  openssl-devel
  python
  python2-crypto
  python-devel
  python2-pip
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

describe package('PyYAML') do
  it { should be_installed.by('pip').with_version('3.13') }
end

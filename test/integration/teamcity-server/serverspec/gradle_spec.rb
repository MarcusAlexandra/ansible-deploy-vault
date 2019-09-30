require 'spec_helper'

  describe yumrepo('epel') do
    it { should exist }
    it { should be_enabled }
  end

 # describe yumrepo('docker-ce-stable') do
 #   it { should exist }
 #   it { should be_enabled }
 #   end


  # %w(bc
  #    nrpe
  #    sysstat
  #    iptraf-ng
  #    bind-utils
  #    rsyslog
  #    yum-utils
  #    epel-release
  #   ).each do |pkg|
  #    describe package "#{pkg}" do
  #      it { should be_installed }
  #      end
  #   end

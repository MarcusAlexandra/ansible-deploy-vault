require 'spec_helper'

  %w(/home/vault
   ).each do |user_dir|
     describe file "#{user_dir}", :if => os[:arch] == 'x86_64' do
        it { should exist }
       it { should be_directory }
       end
    end

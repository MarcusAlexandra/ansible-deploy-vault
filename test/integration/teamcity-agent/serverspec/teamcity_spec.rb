# require 'spec_helper'
#
#   %w(/home/appuser
#      /home/dockermgr
#    ).each do |user_dir|
#      describe file "#{user_dir}", :if => os[:arch] == 'x86_64' do
#        it { should be_directory }
#        end
#     end
#
# %w(/home/appuser/.ssh/authorized_keys
#    /home/dockermgr/.ssh/authorized_keys
#   ).each do |pubkey|
#       describe file "#{pubkey}", :if => os[:arch] == 'x86_64' do
#         it { should exist }
#         it { should be_file }
#       end
#     end

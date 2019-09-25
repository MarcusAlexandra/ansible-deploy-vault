describe group('teamcity') do
  it { should be_local }
  its('users') { should cmp 'teamcity' }
end

describe user('teamcity') do
  it { should exist }
  its('group') { should eq 'teamcity' }
end

describe directory('/opt/teamcity') do
  its('users') { should cmp 'teamcity'  }
end

describe directory('/opt/teamcityBuildServer/lib/jdbc') do
  its('users') { should cmp 'teamcity'  }
end

describe directory('/opt/teamcityBuildServer/config') do
  its('users') { should cmp 'teamcity'  }
end

describe package('postgresql-server') do
  it { should be_installed }
end

describe package('postgresql-devel') do
  it { should be_installed }
end

describe package('postgresql-contrib') do
  it { should be_installed }
end

describe package('java-1.8.0-openjdk') do
  it { should be_installed }
end

describe package('java-1.8.0-openjdk-headless') do
  it { should be_installed }
end

describe package('python2-pip') do
  it { should be_installed }
end

# describe pip('psycopg') do
#   it { should be_installed }
# end

describe service('postgresql') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

sql = postgres_session('teamcity', 'teamcity')

describe sql.query('SELECT datname FROM pg_database WHERE datistemplate = false;') do
  its('output') { should eq(/teamcity/)  }
end

describe file('/var/lib/pgsql/data/pg_hba.conf') do
  it { should exist }
end

describe file(' /opt/teamcity') do
  it { should exist }
end

describe file('opt/teamcity/BuildServer/lib/jdbc/postgresql-42.0.0.jar') do
  it { should be_file }
  its('sha256sum') { should eq '3bec21d1677f6cfce3e49d3578d4c84365264841753941197edf50363de28798'  }
  its('owner') { should eq 'teamcity' }
end

describe file('/opt/teamcity/BuildServer/config/database.properties') do
  it { should exist }
end

describe file('/etc/systemd/system/teamcity.service') do
  it { should exist }
end

describe service('teamcity') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

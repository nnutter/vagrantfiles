class { 'apt' : }

apt::source { 'precise-genome-development' :
  location   => 'http://repo.gsc.wustl.edu/deb/private/ubuntu/',
  release    => 'precise-genome-development',
  repos      => 'main non-free staging',
  key        => 'AD605DFB',
  key_server => 'pgp.mit.edu',
}

$package = [
  'git',
  'libdbd-pg-perl',
  'sqitch-carton',
]
package { $package :
  ensure  => latest,
  require => Apt::Source['precise-genome-development'],
}

class { 'postgresql::server' : }

$genome_dbname = 'genome'
$genome_role  = 'genome'
$gms_role     = 'gms-user'

postgresql::server::role { [$genome_role, $gms_role] : }

postgresql::server::role { 'vagrant' :
  login         => true,
}

# We have to manually 'GRANT role TO role' because 3.3.0 doesn't support it
# yet.  https://github.com/puppetlabs/puppetlabs-postgresql/pull/344
exec { "GRANT \"${genome_role}\" TO vagrant" :
  command => "/usr/bin/psql --dbname=${genome_dbname} --command=\"GRANT \\\"${genome_role}\\\" TO vagrant;\"",
  user    => 'postgres',
  require => [
    Postgresql::Server::Role['vagrant', $genome_role],
    Postgresql::Server::Db[$genome_dbname],
  ],
}

exec { "GRANT \"${gms_role}\" TO vagrant" :
  command => "/usr/bin/psql --dbname=${genome_dbname} --command=\"GRANT \\\"${gms_role}\\\" TO vagrant;\"",
  user    => 'postgres',
  require => [
    Postgresql::Server::Role['vagrant', $gms_role],
    Postgresql::Server::Db[$genome_dbname],
  ],
}

postgresql::server::db { $genome_dbname :
  user     => 'vagrant',
  password => postgresql_password('vagrant', 'password'),
}

postgresql::server::database_grant { "give all privileges to ${genome_role}" :
  privilege => 'ALL',
  db        => $genome_dbname,
  role      => $genome_role,
}

postgresql::server::database_grant { "give all privileges to ${gms_role}" :
  privilege => 'ALL',
  db        => $genome_dbname,
  role      => $gms_role,
}

# We have to manually initialize Sqitch because of an incompatability of Sqitch
# v0.982 with Postgres 9.1.  https://github.com/theory/sqitch/commit/45709d9
exec { 'Initialize Sqitch' :
  command => "/usr/bin/psql --dbname=${genome_dbname} --file /usr/share/sqitch/lib/perl5/App/Sqitch/Engine/pg.sql --set sqitch_schema=sqitch",
  user    => 'vagrant',
  unless  => "/usr/bin/psql --dbname=${genome_dbname} --command='SELECT 1 from sqitch.projects;' > /dev/null",
  require => [
    Postgresql::Server::Role['vagrant'],
    Postgresql::Server::Db[$genome_dbname],
  ],
}

node default { }

node 'db1' {
  include galera
}

node 'db2' {
  include galera
}

node 'db3' {
  include galera
}

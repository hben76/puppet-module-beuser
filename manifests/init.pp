class beuser(
  $ensure = 'present',
  $srcdir = '/opt/eis_di_share/apps/beuser',
  $dstdir = '/bin',
  $name   = 'beuser',
  $mode   = '0755',
  $owner  = 'root',
  $group  = 'root',
) {

  case $::architecture {
    /amd64|sparc/ : { $bitdir = 'x64'  }
    /i386/        : { $bitdir = 'i386' }
    default       : { fail( "Unsupported architecture: ${::architecture}" ) }
  }

  case $::operatingsystem {
    'Solaris' : {
      case $::operatingsystemrelease {
        '5.10' : {
          if $::architecture == 'sparc' {
            $suffix = 'sol10sparc'
          } else {
            $suffix = 'sol10x64'
          }
        }
        default : {
          fail( "Solaris ${::operatingsystemrelease} is not supported" ) 
        }
      }
    }
    /sle[ds]/i : {
      case $::operatingsystemrelease {
        /^10/ : {
          if $::architecture == 'x64' {
            $suffix = 'sles10x64'
          } else {
            $suffix = 'sles10i386'
          }
        }
        /^11/ : {
          if $::architecture == 'x64' {
            $suffix = 'sles11x64'
          } else {
            $suffix = 'sles11i386'
          }
        }
        default : {
          fail( "${::operatingsystem} ${::operatingsystemrelease} is not supported" ) 
        }
      }
    }
    /^RHE/ : {
      case $::operatingsystemrelease {
        /^5/ : { $suffix = 'rhl5' }
        /^6/ : { $suffix = 'rhl6' }
        default : {
          fail( "${::operatingsystem} ${::operatingsystemrelease} is not supported" ) 
        }
      }
    }
    default : {
      fail( "${::operatingsystem} ${::operatingsystemrelease} is not supported" ) 
    }
  }

  file { 'beuser' :
    ensure => $ensure,
    path => "${dstdir}/${name}",
    source => "$srcdir}/${bitdir}/${name}.${suffix}",
    mode   => $mode,
    owner  => $owner,
    group  => $group,
  }
}


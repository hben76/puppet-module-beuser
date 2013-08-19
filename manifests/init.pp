class beuser(
  $ensure = 'present',
  $srcdir = '/opt/eis_di_share/apps/beuser',
  $dstdir = '/bin',
  $binname   = 'beuser',
  $mode   = '0755',
  $owner  = 'root',
  $group  = 'root',
) {

  case $::hardwareisa {
    /amd64|sparc/ : { $bitdir = 'x64'  }
    /i386/        : { $bitdir = 'i386' }
    default       : { fail( "Unsupported architecture: ${::architecture}" ) }
  }

  case $::operatingsystem {
    'Solaris' : {
      case $::operatingsystemrelease {
        /^10/ : {
          if $::hardwareisa == 'sparc' {
            $suffix = 'sol10sparc'
          } else {
            $suffix = 'sol10x64'
          }
        }
        /^9/ : {
          if $::hardwareisa == 'sparc' {
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
    /(?i:sle[ds])/ : {
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
    /(?i:^RHE)/ : {
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
    path => "${dstdir}/${binname}",
    source => "${srcdir}/${bitdir}/${binname}.${suffix}",
    mode   => $mode,
    owner  => $owner,
    group  => $group,
  }
}


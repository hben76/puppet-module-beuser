class beuser(
  $ensure  = 'present',
  $srcdir  = '/opt/eis_cm/eis_cm_repo/beuser',
  $dstdir  = '/bin',
  $binname = 'beuser',
  $mode    = '0755',
  $owner   = 'root',
  $group   = 'root',
) {

  case $::hardwareisa {
    /amd64|sparc/ : { $bitdir = 'x64'  }
    /i386/        : { $bitdir = 'i386' }
    default       : { fail( "Unsupported architecture: ${::architecture}" ) }
  }

  case $::operatingsystem {
    'Solaris' : {
      $sdir = "${srcdir}/x64"
      case $::operatingsystemrelease {
        /^5.1[01]/ : {
          if $::hardwareisa == 'sparc' {
            $suffix = 'sol10sparc'
          } else {
            $suffix = 'sol10x64'
          }
        }
        /^5.9/ : {
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
      $sdir = "${srcdir}/${bitdir}"
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
      $sdir = "${srcdir}/${bitdir}"
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
    source => "${sdir}/${binname}.${suffix}",
    mode   => $mode,
    owner  => $owner,
    group  => $group,
  }
}


# tjaroszewski@mirantis.com [20.06.2015]
#
# - Version for UBUNTU, MOS 5.1.1
# - Check it with -> puppet apply -e "class { 'dsc-cinder-driver-icehouse': }"

include cinder

class dsc-cinder-driver-icehouse (

    # CHANGE ME!
    $san_ip = '',
    $san_login = '',
    $san_password = '',
    $iscsi_ip_address = '',
    $dell_sc_ssn = '',
    $dell_sc_api_port = '3033',
    $dell_sc_server_folder = 'CloudServers',
    $dell_sc_volume_folder = 'CloudServers/Volumes',
    $iscsi_port = '3260') {
    
    package { 'python-six':
        ensure => present }

    #package { 'nokogiri':
    #    ensure => '1.5.11',
    #    provider => 'gem'
    #}

    #package { 'savon':
    #    ensure => '2.7.2',
    #    provider => 'gem'
    #}

    file { 'python-retrying_1.2.3-2~mos6.1_all.deb':
        path => '/tmp/python-retrying_1.2.3-2~mos6.1_all.deb',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0755',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/python-retrying_1.2.3-2~mos6.1_all.deb'
    }

    package { 'python-retrying':
        provider => 'dpkg',
        ensure => installed,
        source => '/tmp/python-retrying_1.2.3-2~mos6.1_all.deb'
    }

    # Converted from *.rpm package using 'alien' script
    #file { 'dell-emclient_15.1.2-46_amd64.deb':
    #    path => '/tmp/dell-emclient_15.1.2-46_amd64.deb',
    #    ensure => file,
    #    owner => 'root',
    #    group => 'root',
    #    mode => '0755',
    #    source => 'puppet:///modules/dsc-cinder-driver-icehouse/dell-emclient_15.1.2-46_amd64.deb'
    #}

    #package { 'dell-emclient_15.1.2-46_amd64.deb':
    #    provider => 'dpkg',
    #    ensure => installed,
    #    source => '/tmp/dell-emclient_15.1.2-46_amd64.deb'
    #}

    file { 'drivers-dell':
        path => '/usr/share/pyshared/cinder/volume/drivers/dell',
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '0755'
    }

    file { 'dell_storagecenter_api.py':
        path => '/usr/share/pyshared/cinder/volume/drivers/dell/dell_storagecenter_api.py',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0644',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/dell/dell_storagecenter_api.py'
    }

    file { 'dell_storagecenter_common.py':
        path => '/usr/share/pyshared/cinder/volume/drivers/dell/dell_storagecenter_common.py',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0644',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/dell/dell_storagecenter_common.py'
    }

    file { 'dell_storagecenter_fc.py':
        path => '/usr/share/pyshared/cinder/volume/drivers/dell/dell_storagecenter_fc.py',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0644',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/dell/dell_storagecenter_fc.py'
    }

    file { 'dell_storagecenter_iscsi.py':
        path => '/usr/share/pyshared/cinder/volume/drivers/dell/dell_storagecenter_iscsi.py',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0644',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/dell/dell_storagecenter_iscsi.py'
    }

    file { '__init__.py':
        path => '/usr/share/pyshared/cinder/volume/drivers/dell/__init__.py',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0644',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/dell/__init__.py'
    }

    #file_line { 'volume_cinder_conf':
    #    ensure => present,
    #    path => '/etc/cinder/cinder.conf',
    #    line => "volume_backend_name=delliscsi\nenabled_backends=delliscsi",
    #    match => '^volume_backend_name=DEFAULT'
    #}

    file { 'i18n.py':
        path => '/usr/share/pyshared/cinder/i18n.py',
        ensure => file,
        owner => 'root',
        group => 'root',
        mode => '0755',
        source => 'puppet:///modules/dsc-cinder-driver-icehouse/i18n.py'
    }

    file { '/usr/lib/python2.7/dist-packages/cinder/volume/drivers/dell':
        ensure => 'link',
        target => '/usr/share/pyshared/cinder/volume/drivers/dell',
    }

    # Template for delliscsi section; Not needed because of usage of 'cinder_config'
    # ensure => template('dsc-cinder-driver-icehouse/cinder_conf.erb'),

    cinder_config {
        'DEFAULT/volume_backend_name':      value => 'delliscsi';
        'DEFAULT/enabled_backends':         value => 'delliscsi';
	'DEFAULT/volume_driver':	    value => 'cinder.volume.drivers.dell.dell_storagecenter_iscsi.DellStorageCenterISCSIDriver';
        'delliscsi/volume_backend_name':    value => 'delliscsi';
        'delliscsi/volume_driver':          value => 'cinder.volume.drivers.dell.dell_storagecenter_iscsi.DellStorageCenterISCSIDriver';
        'delliscsi/san_ip':                 value => $san_ip;
        'delliscsi/san_login':              value => $san_login;
        'delliscsi/san_password':           value => $san_password;
        'delliscsi/iscsi_ip_address':       value => $iscsi_ip_address;
        'delliscsi/dell_sc_ssn':            value => $dell_sc_ssn;
        'delliscsi/dell_sc_api_port':       value => $dell_sc_api_port;
        'delliscsi/dell_sc_server_folder':  value => $dell_sc_server_folder;
        'delliscsi/dell_sc_volume_folder':  value => $dell_sc_volume_folder;
        'delliscsi/iscsi_port':             value => $iscsi_port;
    }

    service { 'cinder-volume':
        ensure => 'running',
        enable => 'true',
        hasstatus  => true,
        hasrestart => true,
        #subscribe => File['/etc/cinder/cinder.conf'],
    }

    service { 'cinder-api':
        ensure => 'running',
        enable => 'true',
        hasstatus  => true,
        hasrestart => true,
        #subscribe => File['/etc/cinder/cinder.conf'],
    }

    service { 'cinder-scheduler':
        ensure => 'running',
        enable => 'true',
        hasstatus  => true,
        hasrestart => true,
        #subscribe => File['/etc/cinder/cinder.conf'],
    }

    #File['/etc/cinder/cinder.conf'] ~> Service['cinder-volume','cinder-api','cinder-scheduler']

    exec { 'Cinder-volume restart':
        command => "/usr/sbin/service cinder-volume restart",
    }

}

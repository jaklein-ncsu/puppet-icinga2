# == Defined type: icinga2::object::livestatuslistener
#
# This is a defined type for Icinga 2 apply objects that create Livestatus Listener
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/object-types#objecttype-livestatuslistener
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::livestatuslistener (
  $object_livestatuslistenername  = $name,
  $socket_type                    = undef,
  $bind_host                      = undef,
  $bind_port                      = undef,
  $socket_path                    = undef,
  $compat_log_path                = undef,
  $target_dir                     = '/etc/icinga2/objects/livestatuslisteners',
  $target_file_name               = "${name}.conf",
  $target_file_ensure             = file,
  $target_file_owner              = 'root',
  $target_file_group              = 'root',
  $target_file_mode               = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation of the class' parameters:
  if $object_livestatuslistenername {
    validate_string($object_livestatuslistenername)
  }
  if $socket_type {
    validate_string($socket_type)
  }
  if $bind_host {
    validate_string($bind_host)
  }
  if $bind_port {
    validate_string($bind_port)
  }
  if $socket_path {
    validate_string($socket_path)
  }
  if $compat_log_path {
    validate_string($compat_log_path)
  }
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_re($target_file_mode, '^\d{4}$')
  validate_bool($refresh_icinga2_service)

  #If the refresh_icinga2_service parameter is set to true...
  if $refresh_icinga2_service == true {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_livestatuslistener.conf.erb'),
      #...notify the Icinga 2 daemon so it can restart and pick up changes made to this config file...
      notify  => Class['::icinga2::service'],
    }

  }
  #...otherwise, use the same file resource but without a notify => parameter:
  else {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_livestatuslistener.conf.erb'),
    }

  }

}

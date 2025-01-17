# == Defined type: icinga2::object::scheduleddowntime
#
#  This is a defined type for Icinga 2 ScheduledDowntime objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/object-types#objecttype-scheduleddowntime
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::scheduleddowntime (
  $object_scheduleddowntimename = $name,
  $host_name                    = undef,
  $service_name                 = undef,
  $author                       = undef,
  $comment                      = undef,
  $fixed                        = true,
  $duration                     = undef,
  $ranges                       = {},
  $target_dir                   = '/etc/icinga2/objects/scheduleddowntimes',
  $target_file_name             = "${name}.conf",
  $target_file_ensure           = file,
  $target_file_owner            = 'root',
  $target_file_group            = 'root',
  $target_file_mode             = '0644',
  $refresh_icinga2_service = true
) {

  #Do some validation of the define's parameters:
  validate_string($object_scheduleddowntimename)
  validate_string($host_name)
  if $service_name {
    validate_string($service_name)
  }
  validate_string($author)
  validate_string($comment)
  validate_bool($fixed)
  validate_string($duration)
  validate_hash($ranges)
  validate_string($target_dir)
  validate_string($target_file_name)
  validate_string($target_file_owner)
  validate_string($target_file_group)
  validate_string($target_file_mode)
  validate_bool($refresh_icinga2_service)

  #If the refresh_icinga2_service parameter is set to true...
  if $refresh_icinga2_service == true {

    file { "${target_dir}/${target_file_name}":
      ensure  => $target_file_ensure,
      owner   => $target_file_owner,
      group   => $target_file_group,
      mode    => $target_file_mode,
      content => template('icinga2/object_scheduleddowntime.conf.erb'),
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
      content => template('icinga2/object_scheduleddowntime.conf.erb'),
    }

  }

}

# == Defined type: icinga2::object::servicegroup
#
# This is a defined type for Icinga 2 servicegroup objects.
# See the following Icinga 2 doc page for more info:
# http://docs.icinga.org/icinga2/latest/doc/module/icinga2/chapter/object-types#objecttype-servicegroup
#
# === Parameters
#
# See the inline comments.
#

define icinga2::object::servicegroup (
  $object_servicegroup_name = $name,
  $display_name = $name,
  $template_to_import = undef,
  $groups = [],
  $target_dir = '/etc/icinga2/objects/servicegroups',
  $target_file_name = "${name}.conf",
  $target_file_ensure = file,
  $target_file_owner = 'root',
  $target_file_group = 'root',
  $target_file_mode = '0644',
  $assign_where = undef,
  $ignore_where = undef,
  $refresh_icinga2_service = true
) {

  #Do some validation of the class' parameters:
  validate_string($object_servicegroup_name)
  validate_string($template_to_import)
  validate_string($display_name)
  validate_array($groups)
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
      content => template('icinga2/object_servicegroup.conf.erb'),
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
      content => template('icinga2/object_servicegroup.conf.erb'),
    }

  }

}

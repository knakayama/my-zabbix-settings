#!/usr/bin/env ruby

require 'yaml'

media_type    = YAML.load_file('./files/media-type.yml')
media_profile = YAML.load_file('./files/media-profile.yml')

# media type
zbx.mediatypes.create_or_update(
    :description => media_type['description'],
    :type        => media_type['type'],
    :smtp_server => media_type['smtp_server'],
    :smtp_helo   => media_type['smtp_helo'],
    :smtp_email  => media_type['smtp_email']
)

# todo:
# tweak severity
# if mediatype already exists, do nothing
# using user.updatemedia
zbx.users.add_medias(
    :userids => [zbx.users.get_id(:alias => "Admin")],
    :media   => [
        {
            :mediatypeid => zbx.mediatypes.get_id(:description => media_profile['Admin']['description']),
            :sendto      => media_profile['Admin']['sendto'],
            :active      => media_profile['Admin']['active'],
            :period      => media_profile['Admin']['period'],
            :severity    => media_profile['Admin']['severity']
        }
    ]
)


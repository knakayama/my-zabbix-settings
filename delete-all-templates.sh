#!/usr/bin/env ruby

require 'logger'
require 'zabbixapi'

log = Logger.new(STDOUT)

zbx = ZabbixApi.connect(
    :url           => ENV['ZABBIX_URI'],
    :user          => ENV['ZABBIX_USER'],
    :password      => ENV['ZABBIX_PASS'],
    :http_user     => ENV['HTTP_USER'],
    :http_password => ENV['HTTP_PASS']
)

template_ids = []
zbx.templates.dump_by_id({}).each do |template|
    unless template_ids.index(template['templateid'])
        template_ids << template['templateid']
        zbx.templates.delete(template['templateid'])
        log.info("template removed: #{template['templateid']}")
    end
end



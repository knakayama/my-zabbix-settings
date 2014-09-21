#!/usr/bin/env ruby

require 'logger'
require 'yaml'
require 'erb'
require 'zabbixapi'

hosts = YAML.load(ERB.new(IO.read('./files/hosts.yml')).result)
log = Logger.new(STDOUT)

zbx = ZabbixApi.connect(
    :url           => ENV['ZABBIX_URI'],
    :user          => ENV['ZABBIX_USER'],
    :password      => ENV['ZABBIX_PASS'],
    :http_user     => ENV['HTTP_USER'],
    :http_password => ENV['HTTP_PASS']
)

#Dir.glob("./files/templates/*.yml") do |file|
#    template = YAML.load_file(file)
#    dependency_hash_table = {}
#
#    # create templates
#    template_id = zbx.templates.create(
#        :host   => template['name'],
#        :groups => template['groups'].map { |t| [:groupid => zbx.hostgroups.get_id(:name => t)] }.flatten
#    )
#    log.info("template created: #{template['name']}")
#
#    # create application
#    template['applications'].each do |application|
#        zbx.applications.create(
#            :name   => application,
#            :hostid => zbx.templates.get_id(:host => template['name'])
#        )
#        log.info("application created: #{application}")
#    end
#
#    # create item
#    template['items'].keys.each do |item|
#        zbx.items.create(
#            :name          => template['items'][item]['name'],
#            :key_          => template['items'][item]['key_'],
#            :delay         => template['items'][item]['delay'],
#            :delta         => template['items'][item]['delta'] || 0,
#            :type          => template['items'][item]['type'],
#            :value_type    => template['items'][item]['value_type'],
#            :units         => template['items'][item]['units'] || "",
#            :hostid        => zbx.templates.get_id(:host => template['name']),
#            :applications  => template['applications'].map { |a| zbx.applications.get_id(:name => a) },
#            :trapper_hosts => template['items'][item]['trapper_hosts'],
#            :formula       => template['items'][item]['formula'],
#            :valuemapid    => template['items'][item]['valuemapid']
#        )
#        log.info("item created: #{template['items'][item]['name']}")
#    end
#
#    # create trigger
#    template['triggers'].keys.each do |trigger|
#        trigger_id = zbx.triggers.create(
#            :description  => template['triggers'][trigger]['description'],
#            :expression   => template['triggers'][trigger]['expression'],
#            :priority     => template['triggers'][trigger]['priority'],
#        )
#        log.info("trigger created: #{template['triggers'][trigger]['description']}")
#
#        if dependency_hash_table[trigger]
#            zbx.triggers.update(
#                :triggerid    => trigger_id,
#                :status       => 1,
#                :dependencies => [
#                    :triggerid => dependency_hash_table[trigger]
#                ]
#            )
#            zbx.triggers.update(
#                :triggerid    => trigger_id,
#                :status       => 0,
#            )
#            log.info("trigger updated: #{template['triggers'][trigger]['description']}")
#        end
#
#        if template['triggers'][trigger]['dependencies']
#            template['triggers'][trigger]['dependencies'].each do |dependency|
#                dependency_hash_table[dependency] = trigger_id
#            end
#        end
#    end
#end

# link templates to host
hosts.keys.each do |host|
    zbx.templates.mass_add(
        :hosts_id     => [zbx.hosts.get_id(:host => hosts[host]['fqdn'])],
        :templates_id => hosts[host]['templates'].values.map { |t| zbx.templates.get_id(:host => t) }
    )
    log.info("template linked: #{host}")
end


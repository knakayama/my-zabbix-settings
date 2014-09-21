#!/usr/bin/env ruby

require 'yaml'
require 'erb'

hosts = YAML.load(ERB.new(IO.read('./files/hosts.yml')).result)

# create host
zbx.hosts.create_or_update(
    :host       => hosts[ENV['ZABBIX_AGENT1_FQDN']]['fqdn'],
    :interfaces => [
        {
            :type  => hosts[ENV['ZABBIX_AGENT1_FQDN']]['interfaces']['eth0']['type'],
            :main  => hosts[ENV['ZABBIX_AGENT1_FQDN']]['interfaces']['eth0']['main'],
            :ip    => hosts[ENV['ZABBIX_AGENT1_FQDN']]['interfaces']['eth0'][ENV['ZABBIX_AGENT1_IP']],
            :dns   => hosts[ENV['ZABBIX_AGENT1_FQDN']]['interfaces']['eth0'][ENV['ZABBIX_AGENT1_FQDN']],
            :port  => hosts[ENV['ZABBIX_AGENT1_FQDN']]['interfaces']['eth0']['port'],
            :useip => hosts[ENV['ZABBIX_AGENT1_FQDN']]['interfaces']['eth0']['useip']
        }
    ],
    :groups => [
        :groupid => zbx.hostgroups.get_id(:name => hosts[ENV['ZABBIX_AGENT1_FQDN']]['groups']['groupid1'])
    ]
)

zbx.hosts.create_or_update(
    :host       => hosts[ENV['ZABBIX_SERVER_FQDN']]['fqdn'],
    :interfaces => [
        {
            :type  => hosts[ENV['ZABBIX_SERVER_FQDN']]['interfaces']['eth0']['type'],
            :main  => hosts[ENV['ZABBIX_SERVER_FQDN']]['interfaces']['eth0']['main'],
            :ip    => hosts[ENV['ZABBIX_SERVER_FQDN']]['interfaces']['eth0']['ip'],
            :dns   => hosts[ENV['ZABBIX_SERVER_FQDN']]['interfaces']['eth0']['dns'],
            :port  => hosts[ENV['ZABBIX_SERVER_FQDN']]['interfaces']['eth0']['port'],
            :useip => hosts[ENV['ZABBIX_SERVER_FQDN']]['interfaces']['eth0']['useip']
        }
    ],
    :groups => [
        :groupid => zbx.hostgroups.get_id(:name => hosts[ENV['ZABBIX_SERVER_FQDN']]['groups']['groupid1'])
    ]
)


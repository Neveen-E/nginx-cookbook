#
# Cookbook:: nginx
# Spec:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'nginx::nginx' do
  context 'When all attributes are default, on Ubuntu 16.04' do
    let(:chef_run) do
      # for a complete list of available platforms and versions see:
      # https://github.com/customink/fauxhai/blob/master/PLATFORMS.md
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '16.04')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'runs apt get update' do
      expect(chef_run).to update_apt_update 'update_sources'
    end

    it 'should install nginx' do
      expect(chef_run).to install_package 'nginx'
    end

    it 'should enable the nginx service' do
      expect(chef_run).to enable_service 'nginx'
    end

    it 'should start the nginx service' do
      expect(chef_run).to start_service 'nginx'
    end

    it 'should create a tempalate' do
      expect(chef_run).to create_template('/etc/nginx/sites-available/proxy.conf')
    end

    it 'should create a symlink of proxy.conf' do
      expect(chef_run).to create_link('/etc/nginx/sites-enabled/proxy.conf').with_link_type(:symbolic)
    end

    it 'should delete the symlink from the default config in sites-enabled' do
      expect(chef_run).to delete_link '/etc/nginx/sites-enabled/default'
    end

    it 'update the name /etc/nginx/sites-available/proxy.conf' do
      template = chef_run.template('/etc/nginx/sites-available/proxy.conf')
      expect(template).to notify('service[nginx]').to(:reload)
    end
  end
end

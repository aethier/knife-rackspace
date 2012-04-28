require 'chef/knife/rackspace_base'

class Chef
  class Knife
    class RackspaceServerDlist < Knife

      include Knife::RackspaceBase

      banner "knife rackspace server dlist"

      def run
        $stdout.sync = true

        server_list = [
          ui.color('Instance ID', :bold),
          ui.color('Public IP', :bold),
          ui.color('Private IP', :bold),
          ui.color('Flavor', :bold),
          ui.color('Image', :bold),
          ui.color('Name', :bold),
          ui.color('Owner', :bold),
          ui.color('State', :bold)
        ]
        connection.servers.all.each do |server|
          server_list << server.id.to_s
          server_list << (server.public_ip_address == nil ? "" : server.public_ip_address)
          server_list << (server.addresses["private"].first == nil ? "" : server.addresses["private"].first)
          server_list << (server.flavor_id == nil ? "" : server.flavor_id.to_s)
          server_list << (server.image_id == nil ? "" : server.image_id.to_s)
          server_list << server.name
          server_list << (server.metadata["owner"] == nil ? "" : server.metadata["owner"])
          
          server_list << begin
            case server.state.downcase
            when 'deleted','suspended'
              ui.color(server.state.downcase, :red)
            when 'build'
              ui.color(server.state.downcase, :yellow)
            else
              ui.color(server.state.downcase, :green)
            end
          end
        end
        puts ui.list(server_list, :uneven_columns_across, 8)
        
      end
    end
  end
end
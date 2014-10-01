require 'ostruct'

module ZNC
  module Helper
    def hashed_pass(pass, salt)
      Digest::SHA256.new.hexdigest "#{pass}#{salt}"
    end

    def formatted_channels_config(channel_attributes)
      channel_attributes || []
    end

    def formatted_network_config(network_attributes)
      return nil unless network_attributes

      OpenStruct.new(
        name:     network_attributes['server'].gsub('.', '_'),
        server:   network_attributes['server'],
        port:     network_attributes['port'],
        channels: formatted_channels_config(network_attributes['channels']),
      )
    end

    def formatted_users_config(user_attributes)
      user_attributes.map do |u|
        OpenStruct.new(
          nick: u['nick'],
          salt: u['salt'],
          pass: hashed_pass(u['pass'], u['salt']),
          network: formatted_network_config(u['network']),
        )
      end
    end
  end
end

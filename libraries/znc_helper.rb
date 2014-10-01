require 'ostruct'

module ZNC
  module Helper
    def hashed_pass(pass, salt)
      Digest::SHA256.new.hexdigest "#{pass}#{salt}"
    end

    def channels_config(attrs)
      attrs || []
    end

    def network_config(attrs)
      return nil unless attrs

      OpenStruct.new(
        name:     attrs['server'].gsub('.', '_'),
        server:   attrs['server'],
        port:     attrs['port'],
        channels: channels_config(attrs['channels']),
      )
    end

    def users_config(user_attributes)
      user_attributes.map do |u|
        OpenStruct.new(
          nick: u['nick'],
          salt: u['salt'],
          pass: hashed_pass(u['pass'], u['salt']),
          network: network_config(u['network']),
        )
      end
    end
  end
end

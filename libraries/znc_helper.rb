module ZNC
  module Helper
    def hashed_pass(pass, salt)
      Digest::SHA256.new.hexdigest "#{pass}#{salt}"
    end

    def formatted_users_config(user_attributes)
      user_attributes.map do |u|
        {
          nick: u['nick'],
          salt: u['salt'],
          pass: hashed_pass(u['pass'], u['salt'])
        }
      end
    end
  end
end

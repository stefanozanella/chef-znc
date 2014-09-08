module ZNC
  module Helper
    def hashed_pass(pass, salt)
      Digest::SHA256.new.hexdigest "#{pass}#{salt}"
    end
  end
end

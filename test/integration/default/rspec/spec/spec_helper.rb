require 'serverspec'

include SpecInfra::Helper::Exec
include SpecInfra::Helper::DetectOS

# See https://tickets.opscode.com/browse/CHEF-3304
Encoding.default_external = Encoding::UTF_8

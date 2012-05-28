require 'pry-remote-em/server'
require 'pry'

def alpha
  b = 10
  beta
end

def beta
  c = "john"
  gamma(c)
end

def gamma(c)
  binding.remote_pry_em
end

# Thread.new {
#   binding.pry
# }

EM.run { alpha }

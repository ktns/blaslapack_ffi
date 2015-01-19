$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'blaslapack_ffi'

require 'rspec/its'

begin
require 'pry-byebug'
rescue LoadError
  begin
    require 'pry-byebug'
  rescue LoadError
  end
end

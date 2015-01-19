# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blaslapack_ffi/version'

Gem::Specification.new do |spec|
  spec.name          = "blaslapack_ffi"
  spec.version       = BlasLapackFFI::VERSION
  spec.authors       = ["Katsuhiko Nishimra"]
  spec.email         = ["ktns.87@gmail.com"]
  spec.summary       = %q{FFI for BLAS/LAPACK routines}
  spec.description   = %q{Ruby FFI for BLAS and LAPACK routines.}
  spec.homepage      = ""
  spec.license       = "GPL"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi", "~> 1.9"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "yard"
end

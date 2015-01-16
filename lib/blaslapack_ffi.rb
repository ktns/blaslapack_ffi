=begin

Copyright Katsuhiko Nishimra, 2015.

This file is part of blaslapack_ffi.

blaslapack_ffi is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

blaslapack_ffi is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with blaslapack_ffi.  If not, see [http://www.gnu.org/licenses/].
=end
require 'ffi'
require "blaslapack_ffi/version"
require "blaslapack_ffi/array"

module BlasLapackFFI
  module BlasFFI
    extend FFI::Library

    ffi_lib "libblas.so"

    attach_function :dnrm2, :dnrm2_, [:pointer, :pointer, :pointer], :double
    attach_function :snrm2, :snrm2_, [:pointer, :pointer, :pointer], :float
  end

  def dnrm2 ary, incx=1
    raise TypeError unless ary.is_a?(DArray)
    incx=incx.to_i
    n = ary.size/incx
    ibuf = FFI::MemoryPointer.new(:int, 2)
    ibuf.write_array_of_int([n, incx])
    return BlasFFI::dnrm2(ibuf, ary.ptr, ibuf+ibuf.type_size)
  end

  def snrm2 ary, incx=1
    raise TypeError unless ary.is_a?(SArray)
    incx=incx.to_i
    n = ary.size/incx
    ibuf = FFI::MemoryPointer.new(:int, 2)
    ibuf.write_array_of_int([n, incx])
    return BlasFFI::snrm2(ibuf, ary.ptr, ibuf+ibuf.type_size)
  end
end

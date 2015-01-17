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
  class FortranArguments < FFI::Struct
    # Allocate a struct and initialize members
    def initialize hash
      super()
      hash.each do |k,v|
        self[k] = v
      end
    end

    # Define a new struct for arguments of a FORTRAN function
    # @param layout [Array] Specifies the layout of the new struct
    # @return the new class that represents the new struct
    def self.define layout
      Class.new(self) do
        self.layout layout
      end
    end

    # @return [Array] Returns an array of pointers to each members
    def to_pointers
      members.map do |k|
        if self.class.layout[k].kind_of?(FFI::StructLayout::Pointer)
          self[k]
        else
          to_ptr + offset_of(k)
        end
      end
    end
  end

  module BlasFFI
    extend FFI::Library

    ffi_lib "libblas.so"

    ##
    # DNRM2 routine
    # @return [Float] Euclidean norm of x
    attach_function :dnrm2, :dnrm2_, [:pointer, :pointer, :pointer], :double
    ##
    # SNRM2 routine
    # @return [Float] Euclidean norm of x
    attach_function :snrm2, :snrm2_, [:pointer, :pointer, :pointer], :float
  end

  DNRM2_ARGS = FortranArguments.define(n: :int, x: :pointer, incx: :int)
  # DNRM2 routine
  # @param [SArray] ary Array of double precision floating number
  # @return [Float] Euclidean norm of x
  def dnrm2 ary
    raise TypeError unless ary.is_a?(DArray)
    incx=ary.incx rescue 1
    n = ary.size
    args = DNRM2_ARGS.new(n: n, incx: incx, x: ary.ptr)
    return BlasFFI::dnrm2(*args.to_pointers)
  end

  SNRM2_ARGS = FortranArguments.define(n: :int, x: :pointer, incx: :int)
  # SNRM2 routine
  # @param [SArray] ary Array of single precision floating number
  # @return [Float] Euclidean norm of x
  def snrm2 ary
    raise TypeError unless ary.is_a?(SArray)
    incx=ary.incx rescue 1
    n = ary.size
    args = DNRM2_ARGS.new(n: n, incx: incx, x: ary.ptr)
    return BlasFFI::snrm2(*args.to_pointers)
  end
end

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
    def initialize *values
      super()
      members.zip values do |k,v|
        case layout[k].type
        when FFI::Type::Builtin::POINTER
          case v
          when FFI::Pointer, nil
            self[k] = v
          else
            self[k] = v.to_ptr
          end
        else
          self[k] = v
        end
      end
    end

    # Define a new struct for arguments of a FORTRAN function
    # @param types [Array<Symbol,String>] types of arguments of a FORTRAN function
    # @return the new class that represents the new struct
    def self.define *types
      layout = types.each_with_index.flat_map do |t, i|
        next :"arg#{i}", t.to_sym
      end
      Class.new(self) do
        self.layout *layout
        public_class_method :new
      end
    end

    private_class_method :new

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

    def inspect
      "#<#{self.class}:#{(members).zip(values).map{|n,v| "#{n} => #{v}"}.join(', ')}>"
    end
  end

  module BlasFFI
    extend FFI::Library

    ffi_lib "libblas.so"
  end

  # Define a wrapper method of a BLAS routine
  # @param name [Symbol,String] name of a BLAS routine, without trailing underscore
  # @param arguments [Array<String, Symbol>] types of arguments for a BLAS routine
  # @param return_type [String, Symbol] type of return value
  def self.define_blas_routine name, arguments, return_type = :void
    arguments = FortranArguments.define(*arguments)
    const_set(:"#{name}_ARGS".upcase, arguments)
    BlasFFI.attach_function(name.to_sym, :"#{name}_", [:pointer]*arguments.members.count, return_type)
    define_method name.to_sym do |*args|
      args=BlasLapackFFI.const_get(:"#{name}_ARGS".upcase).new(*args)
      BlasFFI::send(name.to_sym, *args.to_pointers)
    end
  end

  # @!method dnrm2(n, x, incx)
  # DNRM2 routine
  # @param [Integer] n size of x
  # @param [DArray] x Array of double precision floating number
  # @param [Integer] incx storage spacing of x
  # @return [Float] Euclidean norm of x
  define_blas_routine :dnrm2, %w<int pointer int>, :double

  # @!method snrm2(n, x, incx)
  # SNRM2 routine
  # @param [Integer] n size of x
  # @param [SArray] x Array of single precision floating number
  # @param [Integer] incx storage spacing of x
  # @return [Float] Euclidean norm of x
  define_blas_routine :snrm2, %w<int pointer int>, :float
end

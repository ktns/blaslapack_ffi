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
require "blaslapack_ffi/array"
module BlasLapackFFI
  module Helper
    class FortranArguments < FFI::Struct
      # Allocate a struct and initialize members
      def initialize *values
        input_members = self.class.const_get(:InputMembers)
        raise ArgumentError, "Expected %p and %p have the same size!" % [input_members, values] unless input_members.count == values.count
        super()
        self.class.const_get(:InputTypes).zip input_members, values do |t, k, v|
          case layout[k].type
          when FFI::Type::Builtin::POINTER
            case v
            when FFI::Pointer, nil
              v
            when ::Array
              if t.kind_of? Class and t < BlasLapackFFI::Array
                t[*v]
              else
                v
              end
            else
              v.to_ptr
            end
          else
            v
          end.tap{|v| self[k] = v}
        end
      end

      # Define a new struct for arguments of a FORTRAN function
      # @param types [Array<Symbol,String>] types of arguments of a FORTRAN function
      # @param outonly [Array<true, false>] true if the corresponding argument is output only
      # @return the new class that represents the new struct
      def self.define *types, outonly: [false]*types.count
        raise ArgumentError, "Expected %p and %p have the same size!" % [types, outonly] unless types.count == outonly.count
        layout = types.each_with_index.flat_map do |t, i|
          if (t < BlasLapackFFI::Array rescue false)
            :pointer
          else
            t.to_sym
          end.tap do |t|
            break :"arg#{i}", t
          end
        end
        input_members, input_types = outonly.each_with_index.map do |oonly, i|
          oonly ? nil : [:"arg#{i}", types[i]]
        end.compact.transpose
        Class.new(self) do
          self.layout *layout
          const_set(:InputMembers, input_members)
          const_set(:InputTypes, input_types)
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
    private_constant :FortranArguments

    # Define a wrapper method of a BLAS routine
    # @param name [Symbol,String] name of a BLAS routine, without trailing underscore
    # @param arguments [Array<String, Symbol>] types of arguments for a BLAS routine
    # @param outonly [Array<true, false>] true if the corresponding argument is output only
    # @param return_type [String, Symbol] type of return value
    # @param return_proc [Proc<args, ret>] This proc called after BLAS routine. The returned value is returned by wrapper function.
    def define_blas_routine name, arguments, outonly: [false]*arguments.count, return_type: :void, return_proc: nil
      arguments = FortranArguments.define(*arguments, outonly: outonly)
      const_set(:"#{name}_ARGS".upcase, arguments)
      BlasFFI.attach_function(name.to_sym, :"#{name}_", [:pointer]*arguments.members.count, return_type)
      if return_proc
        define_method name.to_sym do |*args|
          args=BlasLapackFFI.const_get(:"#{name}_ARGS".upcase).new(*args)
          ret = BlasFFI::send(name.to_sym, *args.to_pointers)
          return_proc.call(args.values, ret)
        end
      else
        define_method name.to_sym do |*args|
          args=BlasLapackFFI.const_get(:"#{name}_ARGS".upcase).new(*args)
          BlasFFI::send(name.to_sym, *args.to_pointers)
        end
      end
    end
  end
  private_constant :Helper
end

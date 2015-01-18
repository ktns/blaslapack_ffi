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

module BlasLapackFFI
  class Array
    def initialize size
      @ptr = FFI::MemoryPointer.new(self.class.type, size.to_i).extend(self.class.const_get(:Pointer))
    end

    def size
      @ptr.size / @ptr.type_size
    end

    def [] i
      @ptr.get(i)
    end

    module Singleton
      def [] *args
        self.new(args.size).tap do |a|
          a.instance_eval do
            @ptr.write_array(args)
          end
        end
      end

      def type
        raise NotImplementedError
      end
    end
    extend Singleton

    module Pointer
      def write_array
        raise NotImplementedError
      end

      def get i
        raise NotImplementedError
      end
    end
    attr_reader :ptr
    alias to_ptr ptr
  end

  class DArray < Array
    extend Array::Singleton

    def self.type
      :double
    end

    module Pointer
      def write_array ary
        write_array_of_double ary
      end

      def get i
        get_double(i*type_size)
      end
    end
  end

  class SArray < Array
    extend Array::Singleton

    def self.type
      :float
    end

    module Pointer
      def write_array ary
        write_array_of_float ary
      end

      def get i
        get_float(i*type_size)
      end
    end
  end
end

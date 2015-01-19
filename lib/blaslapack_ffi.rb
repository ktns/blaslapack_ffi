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
require "blaslapack_ffi/version"
require "blaslapack_ffi/helper"

module BlasLapackFFI
  extend Helper
  module BlasFFI
    extend FFI::Library

    ffi_lib "libblas.so"
  end
  private_constant :BlasFFI

  # @!method dnrm2(n, x, incx)
  # DNRM2 routine
  # @param [Integer] n size of x
  # @param [DArray, Array] x Array of double precision floating number
  # @param [Integer] incx storage spacing of x
  # @return [Float] Euclidean norm of x
  define_blas_routine :dnrm2, [:int, DArray, :int], return_type: :double

  # @!method snrm2(n, x, incx)
  # SNRM2 routine
  # @param [Integer] n size of x
  # @param [SArray, Array] x Array of single precision floating number
  # @param [Integer] incx storage spacing of x
  # @return [Float] Euclidean norm of x
  define_blas_routine :snrm2, [:int, SArray, :int], return_type: :float

  # @!method drotg(a, b)
  # DROTG routine
  # @param [Float] a X coordinate of P
  # @param [Float] b Y coordinate of P
  # @return [Array<Float>] r, z, c, s parameters of Givens rotation
  # @see http://www.mathkeisan.com/usersguide/man/drotg.html
  define_blas_routine :drotg, %w<double double double double>,
    outonly: [false, false, true, true],
    return_proc: proc{|(r,z,c,s), _| [r,z,c,s]}

  # @!method srotg(a, b)
  # SROTG routine
  # @param [Float] a X coordinate of P
  # @param [Float] b Y coordinate of P
  # @return [Array<Float>] r, z, c, s parameters of Givens rotation
  # @see http://www.mathkeisan.com/usersguide/man/srotg.html
  define_blas_routine :srotg, %w<float float float float>,
    outonly: [false, false, true, true],
    return_proc: proc{|(r,z,c,s), _| [r,z,c,s]}
end

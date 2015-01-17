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
require 'spec_helper'
require 'blaslapack_ffi'

random_array = Array.new(rand(4..8)){rand(-1.0..1.0)}

describe BlasLapackFFI, random_array: random_array do
  include described_class
  DArray = described_class::DArray
  SArray = described_class::SArray

  let(:random_array){example.metadata[:random_array]}
  let(:norm){random_array.inject(0){|s,n| s+n**2}**0.5}

  describe '#dnrm2' do
    context '(DArray%p)' % [random_array] do
      specify{expect(dnrm2(DArray[*random_array])).to be_within(1e-5).of(norm)}
    end

    context '(SArray[1])' do
      specify{expect{dnrm2(SArray[*random_array])}.to raise_error TypeError}
    end
  end

  describe '#snrm2' do
    context '(SArray%p)' % [random_array] do
      specify{expect(snrm2(SArray[*random_array])).to be_within(1e-5).of(norm)}
    end

    context '(DArray[1])' do
      specify{expect{snrm2(DArray[*random_array])}.to raise_error TypeError}
    end
  end
end

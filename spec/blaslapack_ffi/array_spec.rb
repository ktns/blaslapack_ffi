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
require_relative '../spec_helper.rb'

describe BlasLapackFFI::Array do
  describe '.new' do
    specify{expect{described_class.new(1)}.to raise_error NotImplementedError}
  end

  describe '[1]' do
    specify{expect{described_class[1]}.to raise_error NotImplementedError}
  end
end

shared_context 'a concrete class derived from %s' % BlasLapackFFI::Array, concrete_array: true do
  describe '.new' do
    specify{expect{described_class.new(1)}.not_to raise_error}
  end

  describe '[1]' do
    specify{expect{described_class[1]}.not_to raise_error}
  end

  randsize = rand(4..8)
  describe '%p' % [[1]*randsize], randsize: randsize do
    let(:randsize){example.metadata[:randsize]}
    describe '#size' do
      specify{expect(described_class[*[1]*randsize].size).to eq(randsize)}
    end
  end

  randarray = Array.new(rand(4..8)){rand(-1.0..1.0)}
  describe '%p' % [randarray], randarray: randarray do
    let(:randarray){example.metadata[:randarray]}
    randindex=rand(0...randarray.size)
    describe '[%d]' % randindex, randindex: randindex do
      let(:randindex){example.metadata[:randindex]}
      specify{expect(described_class[*randarray][randindex]).to be_within(1e-5).of(randarray[randindex])}
    end
  end
end

describe BlasLapackFFI::DArray, concrete_array: true

describe BlasLapackFFI::SArray, concrete_array: true

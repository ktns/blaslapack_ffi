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
  specify{expect{described_class.new(1)}.to raise_error NotImplementedError}

  specify{expect{described_class[1]}.to raise_error NotImplementedError}
end

describe BlasLapackFFI::DArray do
  specify{expect{described_class.new(1)}.not_to raise_error}

  specify{expect{described_class[1]}.not_to raise_error}

  let(:randsize){rand(4..8)}
  specify{expect(described_class[*[1]*randsize].size).to eq(randsize)}

  let(:randnum){rand()}
  specify{expect(described_class[randnum][0]).to eq(randnum)}
end

describe BlasLapackFFI::SArray do
  specify{expect{described_class.new(1)}.not_to raise_error}

  specify{expect{described_class[1]}.not_to raise_error}

  let(:randsize){rand(4..8)}
  specify{expect(described_class[*[1]*randsize].size).to eq(randsize)}

  let(:randnum){rand()}
  specify{expect(described_class[randnum][0]).to be_within(1e-5).of(randnum)}
end

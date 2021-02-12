require 'station'

describe Station do
  
  describe '#station' do
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:zone) }

  end
end
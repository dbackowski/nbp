require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#readonly?' do
    it 'returns true' do
      m = Report.new
      expect(m.readonly?).to be_truthy
    end
  end
end

require 'rails_helper'

RSpec.describe feature, type: :model do
  subject do
    feature = Feature.create(name: 'new1234567ssfs', code: 'anytggh657ing', unit_price: '20.to_s',
                             max_unit_limit: '220.to_s')
  end

  describe 'associations' do
    it { should have_many(:features_plans).dependent(:destroy) }
    it { should have_many(:featureusages).dependent(:destroy) }
  end

  describe 'Successfull validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name) }
    it { should validate_presence_of(:code) }
    it { should validate_length_of(:code) }
    it { should validate_numericality_of(:max_unit_limit).is_greater_than(:unit_price) }
  end

  describe 'Negative Scenarios with nill data' do
    subject do
      Feature.new(name: 'Anything1234',
                  code: 'Lorem ipsum23415',
                  max_unit_limit: '32',
                  unit_price: '45')
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a code' do
      subject.code = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid due to absensce' do
      subject.max_unit_limit = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Negative Scenarios with invalid data' do
    subject do
      Feature.new(name: 'Anything34',
                  code: 'Lorm23415',
                  max_unit_limit: '32',
                  unit_price: '4')
    end
    it 'is not valid due to invalid length' do
      subject.name = 'feature'
      expect(subject).to_not be_valid
    end

    it 'is not valid due to invalid length' do
      subject.code = 'code-na'
      expect(subject).to_not be_valid
    end
  end

  describe 'Negative Scenarios with invalid data for unit price' do
    subject do
      Feature.new(name: 'Anything34',
                  code: 'Lorm23415',
                  max_unit_limit: '345',
                  unit_price: '45')
    end

    it 'is not valid due to greater then unit price' do
      subject.unit_price = '333'
      expect(subject).to_not be_valid
    end

    it 'is not valid due to small amount' do
      subject.max_unit_limit = '32'
      expect(subject).to_not be_valid
    end
  end
end

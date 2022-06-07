require 'rails_helper'

RSpec.describe feature, type: :model do
  subject do
    @feature = Feature.create(name: 'new1234567ssfs', code: 'anytggh657ing', unit_price: 20,
                              max_unit_limit: 200)
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
    it { should validate_presence_of(:max_unit_limit) }
    it 'should  allow max_unit greater than unit_price' do
      expect(subject.max_unit_limit).to be >= subject.unit_price
    end
  end

  describe 'Negative Scenarios with nill data for all attributes' do
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

  describe 'Negative Scenarios with invalid data of max_unit_price and min_unit_price' do
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

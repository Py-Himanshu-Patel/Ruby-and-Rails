require 'rails_helper'

RSpec.describe Dummy, type: :model do
  it "age must be less than 21" do
    # create actually create an dummy object and saves it to DB
    dummy = FactoryBot.create(:dummy)
    expect(dummy.age).to be < 21
  end

  it "must have an age greater than 21" do
    dummy = FactoryBot.create(:dummy, age: 22)
    expect(dummy.age).to be > 21
  end

  it "match the single email to factory" do
    dummy = FactoryBot.create(:dummy)
    expect(dummy.email).to eql("my-3@email.com")
  end

  it "match the double email to factory" do
    dummy1 = FactoryBot.create(:dummy)
    dummy2 = FactoryBot.create(:dummy)
    expect(dummy1.email).to eql("my-4@email.com")
    expect(dummy2.email).to eql("my-5@email.com")
  end
end

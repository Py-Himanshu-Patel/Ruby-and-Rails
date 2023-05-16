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

  it "match the email to factory" do
    dummy = FactoryBot.create(:dummy)
    expect(dummy.email).to eql("first@email.com")
  end
end

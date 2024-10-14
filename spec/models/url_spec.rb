require 'rails_helper'

RSpec.describe Url, type: :model do
  it 'is valid with a url' do
    url = Url.new(original_url: 'http://www.example.com', short_url: '123223456765434', title: "example")
    expect(url).to be_valid
  end

  it "is invalid if it has does not have a original url" do
    url = Url.new(
      short_url: "123223456765434"
    )
    expect(url.valid?).to be(false)
  end

  it 'is invalid without a url' do
    url = Url.new(original_url: nil)
    url.valid?
    expect(url.errors[:original_url]).to include("can't be blank")
  end

  it 'is invalid with a wrong url' do
    url = Url.new(original_url: '.example')
    url.valid?
    expect(url.errors[:original_url]).to include("is invalid")
  end
end
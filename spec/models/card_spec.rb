require 'rails_helper'

RSpec.describe Card, type: :model do
  # mock data
  exampleCard = Card.new(id: 1, card_value: 1, card_name: "Ace of Diamonds", deck_id: 1)

  # valid with a name
  it "a card is valid with a card name" do
    expect(exampleCard.card_name).to eq("Ace of Diamonds")
  end

  #valid with a value and value is in the correct range
  it "a card is valid with a correct card_value" do
    expect(exampleCard.card_value).to be_between(1,13)
    expect(exampleCard.card_value).to eq(1)
  end

    #valid with a value and value is in the correct range
    it "a card belongs to a deck" do
      expect(exampleCard.deck_id).to eq(1)
    end

end

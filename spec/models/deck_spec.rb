require 'rails_helper'

RSpec.describe Deck, type: :model do

  exampleCard1 = Card.new(id: 1, card_value: 1, card_name: "Ace of Diamonds", deck_id: 1)
  exampleCard2 = Card.new(id: 2, card_value: 1, card_name: "2 of Diamonds", deck_id: 1)
  exampleCard3 = Card.new(id: 3, card_value: 1, card_name: "3 of Diamonds", deck_id: 1)
  exampleCard4 = Card.new(id: 4, card_value: 1, card_name: "4 of Diamonds", deck_id: 1)
  exampleCard5 = Card.new(id: 5, card_value: 1, card_name: "5 of Diamonds", deck_id: 1)

  cards = [exampleCard1, exampleCard2, exampleCard3, exampleCard4, exampleCard5]

  # shuffling works correctly
  it "a deck can be shuffled properly" do
    shuffledCards = Deck.shuffleCards(cards)
    expect(shuffledCards).to_not eq(cards)
  end

end

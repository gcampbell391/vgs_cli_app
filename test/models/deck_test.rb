require "test_helper"

class DeckTest < ActiveSupport::TestCase

    test "deck should have 52 cards" do
        d1 = decks(:blackjack)
        puts "Deck Name: #{d1.name}"
        # puts "cards: #{d1.cards}"
    end


    # test "find all" do
    #     assert_equal 1, decks.length
    # end

end

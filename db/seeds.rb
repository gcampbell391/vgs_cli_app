# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


puts "Destroying old seed data..."
Player.destroy_all
Dealer.destroy_all
Card.destroy_all
Deck.destroy_all
Game.destroy_all

# Create Player and Dealer
puts "Creating Players..."
player1 = Player.create(name: "Gene")
dealer1 = Dealer.create(name: "Michael")
puts "Player and Dealer created!"

# Create Deck
puts "Creating Deck..."
deck1 = Deck.create(name: "BlackJack Deck")
puts "Deck created!"

# Create Cards
puts "Creating Cards...."
card_suits = ["Diamond", "Heart", "Spade", "Club"]
for x in 1..4 do
    current_number = 1
    13.times do 
        if current_number == 1 
            current_name = "Ace"
            current_card_value = 1
        elsif current_number == 11
            current_name = "Jack"
            current_card_value = 10
        elsif current_number == 12
            current_name = "Queen"
            current_card_value = 10
        elsif current_number == 13
            current_name = "King"
            current_card_value = 10
        else
            current_name = current_number
            current_card_value = current_number
        end 
        Card.create(card_value: current_card_value, card_name: "#{current_name} of #{card_suits[x-1]}s", deck_id: deck1.id)
        current_number += 1
    end
end
puts "Cards created!"


# VGS BlackJack CLI App

# Models

- Player
    - name
    - has many games
- Dealer
    - name
    - has many games
- Card
    - card_name
    - card_value
    - belongs to a deck
- Deck
    - name
    - has many cards
    - has many games
- Game 
    - result
    - belongs to a player
    - belongs to a dealer
    - belongs to a deck

# How To Get Started:
Clone the repo and run the following commands in the terminal to start up the app!
- bundle install 
- rails db:migrate
- rails db:seed
- rails runner bin/cli.rb (This is the command to run the app)

# Built With
- Ruby On Rails 
- tty Prompt

# Game Rules
When the game begins, the dealer deals 1 card to the player, then 1 card to the dealer. The dealer then deals another card to the player. If the player's combined score is 21, then the player automatically wins with Blackjack. If not, The player has two options:

- Hit (Draw another card from the dealer. Take the chance of busting, but increase current score)
- Stay (Stay at current score. Dealer's turn is next)

The dealer will reveal their second card, and if the dealer has 21, they win. If not, the dealer will continue to hit (draw another card) until their score is 17 or higher. 

Ways a Player Can Win:
- Score 21
- Stay at current score, and dealer busts
- Stay at current score, and dealer stays at a lower score

Ways a Dealer Can Win:
- Score 21
- Stay at current score, player has a lower score
- Player busts 

Game is tied if the dealer and player stay at the same score, and nobody wins. 
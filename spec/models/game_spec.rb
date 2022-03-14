require 'rails_helper'

RSpec.describe Game, type: :model do
  

  # Start starts and returns boolean value
  it "game starts properly and returns boolean value" do
    startGame = Game.run()
    expect(startGame).to be_in([true, false])
  end


  


end

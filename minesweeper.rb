# encoding: UTF-8
require 'yaml'
require './minefield.rb'

class Game
  BITS = %w(HEAD ARM BUTT LEGS FACE PET-TURTLE)
  attr_reader :map
  
  def initialize(matrix_side_length, number_of_bombs)
    @minefield = MineField.new(matrix_side_length, number_of_bombs)
  end
  
  def play
    begin
      display
      move(*get_input)
    end until win?
    display
    win_message
  end
  
  def save
    File.open('saved_game.txt', 'w') do |f|
      f.print @minefield.to_yaml
    end
  end
  
  def load
    field = YAML.load(File.read('saved_game.txt'))
    if field.is_a?(MineField)
      @minefield = field
    else
      puts "-----NO SAVED GAME-----" 
    end 
      
  end
  
  def display
    @minefield.display
  end
  
  def win_message
    puts "YOU HAVE WON!!!"
    puts "YOU DID NOT LOSE YOUR #{BITS.sample}!!!"
    puts "I LIKE YOU!!!!"
  end
  
  def move(y, x = nil, flagging = false)
    unless x
      if y == 's'
        save
        return
      else
        load
        return
      end
    end
    if flagging
      @minefield[[x.to_i, y.to_i]].flag
    else
      @minefield[[x.to_i, y.to_i]].sweep
      lose if @minefield[[x.to_i, y.to_i]].bomb?
    end
  end
  
  def get_input
    valid = false
    until valid
      prompt
      choice = gets.split
      valid = check_valid(choice)
    end
    choice
  end
  
  # refactor with Error stuff.
  def check_valid(choice)
    return false unless choice.length.between?(1,3)
    if choice.length.between?(2, 3)
      return false unless choice[0].between?("0", (@minefield.matrix_side_length - 1).to_s)
      return false unless choice[1].between?("0", (@minefield.matrix_side_length - 1).to_s)
      return true if choice.length == 3 && choice[2].downcase == "f"
      return true
    end
    
      return true if choice[0].downcase == "s" || choice[0].downcase == "l"
      puts
      puts "---WARNING---"
      puts "Never operate a minesweeper device without RTFM!"
      puts "---WARNING---"
      puts
      
      false
  end
  
  def prompt
    puts "enter s to save or l to load a game"
    puts "to sweep, enter x and y index seperated by a space. (0 0)"
    puts "follow indices with 'f' if you want to flag (0 0 f)"
  end
  
  def win?
    @minefield.win?
  end
  
  def lose
    display
    puts "BOOOOM!"
    puts "YOU HAVE LOST YOUR #{BITS.sample}!!!"
    exit 
  end
  
end

Game.new(9, 11).play

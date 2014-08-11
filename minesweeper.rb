# encoding: UTF-8

class Cell
  
  attr_accessor :indices
  
  # refactor CRUFT
  def initialize indices, bomb = false
    @indices = indices
    @bomb = false
    @visible = false
    @neighbors = []
    @flagged = false
  end
  
  def click # try renaming
    if self.bomb?
      @visible = true
      return false 
    end
    return true if self.flagged?
    @visible = true
    if number == 0
      @neighbors.each do |node|
        node.click unless node.visible?
      end
    end
    true
  end
  
  def to_s
    return "🏁" if @flagged 
    return "◼️" unless @visible
    return "💣" if bomb?
    num = number
    
    return "8️⃣" if num == 8
    return "7️⃣" if num == 7
    return "6️⃣" if num == 6
    return "5️⃣" if num == 5
    return "4️⃣" if num == 4
    return "3️⃣" if num == 3
    return "2️⃣" if num == 2
    return "1️⃣" if num == 1
    return "0️⃣" if num == 0
  end
  
  def flag
    # @flagged = !@flagged
    if @flagged
      @flagged = false
    else
      @flagged = true
    end
  end
  
  def flagged?
    @flagged
  end
  
  def set_bomb
    @bomb = true
  end
  
  def number
    count = 0
    
    @neighbors.each do |node|
      count += 1 if node.bomb?
    end
    
    count
  end
  
  def add_neighbor(node)
    @neighbors << node
  end
  
  def bomb?
    @bomb
  end
  
  def visible?
    @visible
  end
  
end

class Map 
  DELTAS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1,-1], [1, 0], [1, 1]]
  
  attr_reader :matrix_side_length
  
  def initialize(matrix_side_length, number_of_bombs)
    @matrix_side_length = matrix_side_length
    @number_of_bombs = number_of_bombs
    @nodes = []
    generate_nodes
    link_nodes
  end
  
  def display
    display_matrix = Array.new(@matrix_side_length) {[]}
    print ' '
    @matrix_side_length.times do |i|
      print "  #{i}"
    end
    puts 
    
    @matrix_side_length.times do |x|
      print x
      @matrix_side_length.times do |y|
        print "  #{self[[x, y]]}"
      end
      puts
    end
    puts
  end
  
  def win?
    @nodes.each do |node|
      return false if node.bomb? && !node.flagged?
      return false if !node.bomb? && !node.visible?
    end
    true
  end
  #
  # def line
  #   "-" * ((2 * @matrix_side_length) + 1)
  # end
  #
  def generate_nodes
    indices = []
    @matrix_side_length.times do |i|
      @matrix_side_length.times do |j|
        indices << [i,j]
      end
    end
    
    indices.each do |i|
      @nodes << Cell.new(i)
    end
    
    add_bombs(indices)
  end
    
  def add_bombs indices  
    bomb_indices = indices.sample(@number_of_bombs)
    bomb_indices.each { |i| self[i].set_bomb }
  end
  
  def [] indices
    @nodes.each do |node|
      return node if node.indices == indices
    end
    nil
  end
  
  def link_nodes
    @nodes.each do |node|
      neighboring_indices(node.indices).each do |indices|
        node.add_neighbor(self[indices])
      end
    end
  end
  
  def neighboring_indices(indices)
    possible_indices = DELTAS.map { |x, y| [indices.first + x, indices.last + y] }
    possible_indices.select do |x, y| 
      (x > - 1 && x < @matrix_side_length) &&
      (y > - 1 && y < @matrix_side_length)
    end
  end
end

class Game
  BITS = %w(HEAD ARM BUTT LEGS FACE PET-TURTLE)
  attr_reader :map
  
  def initialize(matrix_side_length, number_of_bombs)
    @map = Map.new(matrix_side_length, number_of_bombs)
  end
  
  def play
    begin
      display
      move(*get_input)
    end until win?
    display
    win_message
  end
  
  def display
    @map.display
  end
  
  def win_message
    puts "YOU HAVE WON!!!"
    puts "YOU DID NOT LOSE YOUR #{BITS.sample}!!!"
    puts "I LIKE YOU!!!!"
  end
  
  def move(y, x, flagging = false)
    if flagging
      @map[[x.to_i, y.to_i]].flag
    else
      @map[[x.to_i, y.to_i]].click
      lose if @map[[x.to_i, y.to_i]].bomb?
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
    return false unless choice.length.between?(2,3)
    return false unless choice[0].to_i.between?(0, @map.matrix_side_length - 1)
    return false unless choice[1].to_i.between?(0, @map.matrix_side_length - 1)
    
    choice[2].downcase == "f" if choice[2]
    true
  end
  
  def prompt
    puts "enter x and y index seperated by a space. (0 0)"
    puts "follow indices with 'f' if you want to flag (0 0 f)"
  end
  
  # forwardable
  def win?
    @map.win?
  end
  
  def lose
    display
    puts "BOOOOM!"
    puts "YOU HAVE LOST YOUR #{BITS.sample}!!!"
    exit 
  end
  
end


# class OldMap
#
#   attr_accessor :matrix
#
#   def initialize matrix = nil
#     @num_bombs = 11
#     @matrix_side_length = 9
#     matrix ||= random_matrix
#     @matrix = matrix
#   end
#
#   def empty_matrix
#     Array.new { [" "] }
#   end
#
#   def random_matrix
#     indices = []
#     @matrix_side_length.times do |i|
#       @matrix_side_length.times do |j|
#         indices << [i,j]
#       end
#     end
#
#     bomb_indices = indices.sample(@num_bombs)
#     new_matrix = empty_matrix
#
#     bomb_indices.each do |location|
#       new_matrix[location.first][location.last] = "B"
#     end
#
#     new_matrix
#   end
#
#   def [] indices
#     @matrix[indices[0], indices[1]]
#   end
#
# end
g = Game.new(9, 11)
g.play

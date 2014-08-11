class Cell
  
  attr_accessor :indices
  
  def initialize indices, bomb = false, clicked = false
    @indices = indices
    @bomb = false
    @visible = false
    @neighbors = []
    @flagged = false
  end
  
  def click
    return false if self.bomb?
    return true if self.flagged?
    @visible = true
    if number == 0
      @neighbors.each do |node|
        node.click
      end
    end
    true
  end
  
  def to_s
    return '*' unless @visible
    return 'B' if bomb?
    num = number
    return num.to_s if num > 0
    return "_"
  end
  
  def flag
    @flagged = true
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
  
  def add_neighbor( node )
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
  @nodes
  
  
  def initialize(matrix_side_length, number_of_bombs)
    @matrix_side_length = matrix_side_length
    @number_of_bombs = number_of_bombs
    @nodes = []
    generate_nodes
    puts @nodes
  end
  
  def display
    display_matrix = Array.new(@matrix_side_length) {[]}
    puts
    @matrix_side_length.times do |x|
      print "|"
      @matrix_side_length.times do |y|
        print "#{self[[x, y]]}|"
      end
      puts
    end
    puts
  end
  
  def line
    "-" * ((2 * @matrix_side_length) + 1)
  end
  
  def generate_nodes
    indices = []
    @matrix_side_length.times do |i|
      @matrix_side_length.times do |j|
        indices << [i,j]
      end
    end
    
    p indices
    
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
  
  def link_up
    @nodes.each do |node|
      neighboring_indices(node.indices).each do |indices|
        node.add_neighbor(neighboring_indices(self[indices]))
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
  
  def initialize(matrix_side_length, number_of_bombs)
    @map = Map.new(matrix_side_length, number_of_bombs)
  end
  
  
  
  def display
  end
  
  def win?
  end
  
  def lose?
  end
  
  def click
    
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
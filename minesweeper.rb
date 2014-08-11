class Cell
  
  attr_accessor :indices
  
  def initialize indices, bomb = false, clicked = false
    @indices = indices
    @bomb = false
    @clicked = false
  end
  
  def set_bomb
    @bomb = true
  end
  
  def add_neighbor( node )
    @neighbors << node
  end
  
  def bomb?
    @bomb
  end
  
  def clicked?
    @clicked
  end
  
end

class Map 
  DELTAS = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1,-1], [1, 0], [1, 1]]
  @nodes
  
  
  def initialize
    @matrix_side_length = 9
    @number_of_bombs = 11
    @nodes = []
    generate_nodes
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
m = Map.new
p m[[1, 1]].clicked?
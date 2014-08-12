# encoding: UTF-8

require './cell.rb'

class MineField
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
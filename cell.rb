# encoding: UTF-8

class Cell
  
  attr_accessor :indices
  
  def initialize indices
    @indices = indices
    @bomb = false
    @visible = false
    @neighbors = []
    @flagged = false
  end
  
  def sweep
    if self.bomb?
      @visible = true
      return false 
    end
    return true if self.flagged?
    @visible = true
    if number == 0
      @neighbors.each do |node|
        node.sweep unless node.visible?
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
    return "◻️" if num == 0
  end
  
  def flag
    @flagged = !@flagged
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
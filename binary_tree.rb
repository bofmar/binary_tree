class Node
  include Comparable
  attr_accessor :value, :left, :right
  def initialize value = nil, left = nil, right = nil 
    @value = value
    @left = left
    @right = right
  end

  def <=> other
    other_val = (other.class == Node) ? other.value : other
    value <=> other_val
  end
end

class Tree
  attr_accessor :arr, :root, :local_arr, :queue
  def initialize arr
    @arr = arr
    @local_arr = sort_arr
    @root = build_tree(0,local_arr.length - 1)
    @queue = []
  end

  def insert value
    node = _insert(value,root)
    if node == nil
      p "Duplicate value detected. Stoping operation"
      return 0 # they attempted to insert an already existring value
    end
    newNode = Node.new(value)
    if newNode > node
      node.right = newNode
    else
      node.left = newNode
    end
  end

  def delete value
    if find(value) == nil # check if the node exists
      p "No such node exists. Operation failed successfuly"
      return root
    end
    _delete value, root
  end

  def find value
    result = _find value, root
    return (result.value == value) ? result : nil
  end

  def level_order
    if root == nil
      return
    end
    result = []
    queue.push root
    while(queue.length != 0)
      current = queue.shift
      result << current.value
      if current.left != nil
        queue << current.left
      end
      if current.right != nil
        queue << current.right
      end
    end
    return result
  end

  def inorder
    return _inorder root
  end

  def preorder
    return _preorder root
  end

  def postorder
    return _postorder root
  end

  def height value
    if find(value) == nil
      p "No such node exists. Operation failed successfuly"
      return
    end
    node = find(value)
    return _height node
  end

  def depth value
    if find(value) == nil
      p "No such node exists. Operation failed successfuly"
      return
    end
    return _depth value, root
  end

  def balanced?
    right_height = _height root.right
    left_height = _height root.left
    return (right_height - left_height).abs <= 1
  end

  def rebalance
    array = level_order
    @local_arr = sort_arr(array)
    @root = build_tree(0,local_arr.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  private
  
  def build_tree start, ending
    if start > ending
      return nil
    end

    mid = (start + ending) / 2
    root = Node.new(local_arr[mid])
    
    root.left = build_tree(start, mid -1)
    root.right = build_tree(mid+1,ending)

    return root
  end
  
  def sort_arr array = arr
    new_arr =[]
    # remove duplicates
    for i in 0...array.length
      unless new_arr.include? array[i]
        new_arr << array[i]
      end
    end
    return new_arr.sort # sort then return the new array
  end

  def _insert value, node
    if value < node.value
      if node.left == nil
        return node
      else
        node = _insert value, node.left
      end
    elsif value > node.value
      if node.right == nil
        return node
      else
        node = _insert value, node.right
      end
    else
      node = nil
    end
    return node
  end

  def _find value, node
    if node.value == value || node.left == nil && node.right == nil
      return node
    end

    if value < node.value
      node = _find value, node.left
    end

    if value > node.value
      node = _find value, node.right
    end
    
    node
  end

  def _delete value, node
    if node == nil
      return node
    end

    if value < node.value
      node.left = _delete(value,node.left)
    elsif value > node.value
      node.right = _delete(value,node.right)
    else
      if node.left == nil
        return node.right
      elsif node.right == nil
        return node.left
      end
      successor = _get_successor node.right
      node.value = successor.value
      node.right = _delete node.value, node.right
    end
    return node
  end

  def _get_successor node
    if node.left == nil
      return node
    end
    node = _get_successor node.left
    return node
  end

  def _inorder node, arr = []
    if node == nil
      return
    end
    _inorder node.left,arr
    arr << node.value
    _inorder node.right,arr
    return arr
  end

  def _preorder node, arr = []
    if node == nil
      return
    end
    arr << node.value
    _preorder node.left,arr
    _preorder node.right,arr
    return arr
  end

  def _postorder node, arr = []
    if node == nil
      return
    end
    _postorder node.left,arr
    _postorder node.right,arr
    arr << node.value
    return arr
  end

  def _height node, height_val = 0, arr = []
    if node.left == nil && node.right == nil
      arr << height_val
    end
    height_val += 1
    if node.right != nil
      _height node.right, height_val, arr
    end
    if node.left != nil
      _height node.left, height_val, arr
    end
    return arr.sort.pop
  end

  def _depth value, node, depth_val = 0
    if node.value == value
      return depth_val
    end
    depth_val += 1
    if value < node.value
      depth_val = _depth value, node.left , depth_val
    end
    if value > node.value
      depth_val = _depth value, node.right, depth_val
    end
    return depth_val
  end
end


# 8. Print out all elements in level, pre, post, and in order

array = Array.new(15) { rand(1..100) }
tree = Tree.new(array)
tree.pretty_print
p "Tree is balanced: #{tree.balanced?}"
p "Level Order: #{tree.level_order}"
p "Pre Order: #{tree.preorder}"
p "Post Order: #{tree.postorder}"
p "In Order: #{tree.inorder}"

tree.insert 105
tree.insert 316
tree.insert 196
tree.insert 475
tree.insert 831
tree.insert 367

tree.pretty_print
p "Tree is balanced: #{tree.balanced?}"
tree.rebalance
tree.pretty_print
p "Tree is balanced: #{tree.balanced?}"
p "Level Order: #{tree.level_order}"
p "Pre Order: #{tree.preorder}"
p "Post Order: #{tree.postorder}"
p "In Order: #{tree.inorder}"
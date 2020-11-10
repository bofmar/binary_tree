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
  attr_accessor :arr, :root, :local_arr
  def initialize arr
    @arr = arr
    @local_arr = sort_arr
    @root = build_tree(0,local_arr.length - 1)
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
    @root = _delete value
  end

  def find value
    result = _find value, root
    return (result.value == value) ? result : nil
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
  
  def sort_arr
    new_arr =[]
    # remove duplicates
    for i in 0...arr.length
      unless new_arr.include? arr[i]
        new_arr << arr[i]
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

  def _delete value
    if find(value) == nil # check if the node exists
      p "No such node exists. Operation failed successfuly"
      return root
    else
      if root.value == value # TO DO: FIX THIS, IT IS WRONG
        parent = root
        if root.right == nil && root.left == nil
          return nil
        end
      else
        parent = _find_parent value, root
      end
      if parent.value > value
        child = parent.left
      else
        child = parent.right
      end
      if child.left == nil && child.right == nil # we are deleting a leaf node
        if parent.value > value
          parent.left = nil
        else
          parent.right = nil
        end
      elsif child.left == nil && child.right != nil || child.right == nil && child.left != nil #only one grandchild exists
        if parent.value > value
          if child.left == nil
            grandchild = child.right
            child.right = nil
            parent.left = grandchild
          else
            grandchild = child.left
            child.left = nil
            parent.left = grandchild
          end
        else
          if child.left == nil
            grandchild = child.right
            child.right = nil
            parent.right = grandchild
          else
            grandchild = child.left
            child.left = nil
            parent.right = grandchild
          end
        end
      else # two grandchildren exist
        inheritor = _find_inheritor child.right
        grandchild = _find_parent inheritor.value, root

        if grandchild == child #the node we are replacing is the same as the parent of the inheritor
          if parent.value > value
            parent.left = inheritor
          else
            parent.right = inheritor
          end
          child.right = nil
          inheritor.left = child.left
          child.left = nil
        else
          if parent.value > value
            parent.left = inheritor
          else
            parent.right = inheritor
          end
          grandchild.left = inheritor.right
          inheritor.left = child.left
          inheritor.right = child.right
          child.left = nil
          child.right = nil
        end
      end
    end
    return root
  end

  def _find_parent value, node
    if node.left != nil && node.left.value == value || node.right != nil && node.right.value == value
      return node
    elsif node.value > value
      node = _find_parent value,node.left
    else
      node = _find_parent value,node.right
    end
    return node
  end

  def _find_inheritor node
    if node.left == nil
      return node
    else
      node = _find_inheritor node.left
    end
    return node
  end
end

# TESTS
testNode = Node.new(5)
test_arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new test_arr
testNode.left = Node.new(6)

tree.pretty_print
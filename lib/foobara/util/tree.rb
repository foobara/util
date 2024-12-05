module Foobara
  module Util
    class SubTree
      attr_accessor :value, :parent_tree, :to_parent

      def initialize(value, to_parent = nil, &block)
        self.value = value
        self.to_parent = to_parent.nil? ? block : to_parent.to_proc
      end

      def root?
        parent_tree.is_a?(Tree)
      end

      def children_trees
        @children_trees ||= []
      end

      def add(object)
        return if include?(object)

        parent = to_parent.call(object)

        parent_node = if parent
                        node_for(parent) || add(parent)
                      else
                        self
                      end

        child_tree = SubTree.new(object, to_parent)
        child_tree.parent_tree = parent_node
        parent_node.children_trees << child_tree

        child_tree
      end

      def node_for(value)
        return self if value == self.value

        children_trees.each do |child|
          node = child.node_for(value)
          return node if node
        end

        nil
      end

      def include?(value)
        !!node_for(value)
      end

      # TODO: try to break this up a bit
      def to_s(to_name, padding: "", last_child: true)
        output = StringIO.new
        name = to_name.call(value)

        padding = puts_box(output, name, padding, last_child)

        children = children_trees.sort_by { |child_tree| to_name.call(child_tree.value) }
        last = children.last

        children.each do |child_tree|
          output.puts child_tree.to_s(to_name, padding:, last_child: child_tree == last)
        end

        output.string
      end

      private

      def puts_box(output, name, padding, last_child)
        name_size = name.size + 1
        name_size_left = name_size / 2
        name_size_right = name_size - name_size_left

        bottom_connector = children_trees.any? ? "┬" : "─"

        if root?
          output.puts "╭#{"─" * (name.size + 2)}╮"
          output.puts "│ #{name} │"
          output.puts "╰#{"─" * name_size_left}#{bottom_connector}#{"─" * name_size_right}╯"
        else
          padding += " "

          connector = last_child ? "└" : "├"
          padding_end = last_child ? "  " : "│ "

          output.print padding
          output.print "│ "

          output.puts "╭#{"─" * (name.size + 2)}╮"
          output.print "#{padding}#{connector}"
          output.puts "─┤ #{name} │"

          padding += padding_end

          output.puts "#{padding}╰#{"─" * name_size_left}#{bottom_connector}#{"─" * name_size_right}╯"
        end

        padding + (" " * (name_size / 2))
      end
    end

    class Tree < SubTree
      def initialize(data, to_parent = nil, &)
        super(nil, to_parent, &)

        data.each do |object|
          add(object)
        end
      end

      def to_s(to_name = nil, &block)
        to_name = if to_name
                    to_name.to_proc
                  elsif block_given?
                    block
                  else
                    :to_s.to_proc
                  end

        children_trees.map { |child| child.to_s(to_name) }.join("\n")
      end
    end

    module_function

    def print_tree(data, io: $stdout, to_name: nil, to_parent: nil)
      data = data.to_a if data.is_a?(::Hash)

      if to_name.nil? && to_parent.nil?
        to_name = :first.to_proc
        to_parent = proc do |object|
          parent_name = object.last
          data.find { |pair| pair.first == parent_name }
        end
      end

      tree = Util::Tree.new(data, to_parent)

      io.puts tree.to_s(to_name)
    end
  end
end

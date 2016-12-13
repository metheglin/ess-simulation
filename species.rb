class Species

  ROOT = Species.new

  attr_accessor :next, :back

  class << self
    include Enumerable

    def last( node=ROOT )
      return node if node.next.nil?
      node = last node.next
    end

    def node_list( node=ROOT, msg = nil )
      msg ||= ""
      return msg[0..-4] if node.nil?
      node_list(node.next, msg << "#{node.to_s} -> ")
    end

    def each( &block )
      indiv = ROOT
      while indiv = indiv.next
        block.call( indiv )
      end
    end

    def bruteforce( &block )
      indiv = ROOT
      while indiv = indiv.next
        indiv2 = indiv
        while indiv2 = indiv2.next
          block.call( indiv, indiv2 )
        end
      end
    end

    def avg( &block )
      list = map( &block )
      list.reduce(:+).to_f / list.size
    end
  end

end

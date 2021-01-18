class Rule
    def initialize(map: nil, type: nil, id: nil)
        if map then
            initialize_from_map map
        else
            initialize_from_typeid(type, id)
        end
    end

    def match?(user)
        if @type == :user
            return user.id == @id
        elsif @type == :role
            return user.role? @id
        end
        
        return false
    end

    def to_s
        return "#{@type} #{@id}"
    end

    private
    def initialize_from_map(map)
        initialize_from_typeid(map["type"].to_sym, map["id"])
    end

    def initialize_from_typeid(type, id)
        @type = type.to_sym
        @id = id.to_i
    end
end

def load_rules(list)
    return [] unless list

    rule_array = []
    list.each do |rule_map|
        rule_array.append Rule.new(map: rule_map)
    end

    return rule_array
end

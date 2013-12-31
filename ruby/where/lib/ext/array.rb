class Array
  def where args
    return [] unless args.is_a? Hash

    find_all do |i|
      args.all? do |k, v|
        case v
        when String
          v == i[k]
        when Regexp
          v.match i[k]
        when Numeric
          v == i[k]
        end
      end
    end
  end
end
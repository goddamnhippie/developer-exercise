class Array
  def where args
    return [] unless args.is_a? Hash

    select do |i|
      args.all? do |k, v|
        case v
        when String, Numeric
          v == i[k]
        when Regexp
          v === i[k]
        end
      end
    end
  end
end
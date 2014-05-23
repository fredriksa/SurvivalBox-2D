class Hash
  def add(start_range, end_range, value)
    (start_range..end_range).each do |index|
      self[index] = value
    end
  end
end
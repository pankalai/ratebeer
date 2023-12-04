module TopN
  def top(amount)
    all.sort_by(&:average_rating).reverse.first(amount)
  end
end

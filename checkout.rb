class Checkout
  attr_accessor :basket
  def initialize(promotional_rules = nil)
    raise_error('promotional_rules nil') unless check_nil_empty(promotional_rules)
    @rule1 = promotional_rules[:rule1]
    @rule2 = promotional_rules[:rule2]
    # validate rule
    # ..... 

    @product_items = promotional_rules[:items]
    # validate product_items
    raise_error('product items nil') unless check_nil_empty(@product_items)

    # get array items_code
    @product_codes = @product_items.map{|x| x[:product_code]}

    # init basket empty
    @basket = []
  end

  def scan(item_code)
    item_code = item_code.to_s
    raise_error('Not found item') unless @product_codes.include?(item_code)
    item = @product_items.find {|product_code| product_code[:product_code] == item_code}
    item[:pay_price] = item[:price]
    @basket << item
  end

  def total
    basket_array_item_code = @basket.map{|x| x[:product_code]}
    # rule2
    if basket_array_item_code.count(@rule2['item_code']) >= @rule2['quantity']
      @basket.each_with_index do |item, index|
        @basket[index][:pay_price] = @rule2['item_pay_price'] if item[:product_code] == @rule2['item_code']
      end
    end
    caculate_payment_total_price
  end

  def caculate_payment_total_price
    # rule1
    payment_total_price = @basket.map{|x| x[:pay_price]}.sum
    payment_total_price *= (1.to_f-(@rule1['percent_discount'].to_f/100)) if payment_total_price >= @rule1['spent_amount']
    payment_total_price.round(2)
  end

  # params: object
  # resp: false unless object.present?
  def check_nil_empty(object)
    return false if object.nil? || object.empty?
    true
  end

  # can customer error abc << StandardError
  def raise_error(message)
    raise StandardError.new message
  end
end
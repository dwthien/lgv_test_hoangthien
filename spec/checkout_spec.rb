require 'spec_helper'

require_relative '../checkout'

describe Checkout do
  let(:test_cfg) { load_spec_conf }

  let(:items) do
    [
      {
        product_code: '001',
        name: 'Lavender heart',
        price: 9.25
      },
      {
        product_code: '002',
        name: 'Personalised cufflinks',
        price: 45
      },
      {
        product_code: '003',
        name: 'Kids T-shirt',
        price: 19.95
      }
    ]
  end

  let(:promotional_rules) do
    {
      rule1:  test_cfg['rule1'],
      rule2:  test_cfg['rule2'],
      items:  items
    }
  end
  let(:co) do
    Checkout.new(promotional_rules)
  end

  let(:co_error_promotional_rules) do
    Checkout.new(nil)
  end

  describe 'Test data' do
    p 'Test data'
    p '---------'
    let(:perform_test0) do
      co_error_promotional_rules.scan('001')
    end

    it 'should raises StandardError exception' do
      expect{perform_test0}.to raise_error(StandardError)
    end

    let(:perform_test1) do
      co.scan('001')
      co.scan('002')
      co.scan('003')
      co.total
    end

    it 'should perform_test1' do
      expect(perform_test1).to eq(66.78)
      p "Basket: #{co.basket.map{|x| x[:product_code]}}"
      p "Total price expected: 66.78"
    end

    let(:perform_test2) do
      co.scan('001')
      co.scan('003')
      co.scan('001')
      co.total
    end

    it 'should perform_test2' do
      expect(perform_test2).to eq(36.95)
      p "Basket: #{co.basket.map{|x| x[:product_code]}}"
      p "Total price expected: 36.95"
    end

    let(:perform_test3) do
      co.scan('001')
      co.scan('002')
      co.scan('001')
      co.scan('003')
      co.total
    end

    it 'should perform_test3' do
      expect(perform_test3).to eq(73.76)
      p "Basket: #{co.basket.map{|x| x[:product_code]}}"
      p "Total price expected: 73.76"
    end
  end
end

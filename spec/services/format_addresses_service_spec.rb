# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe FormatAddressesService do
  let!(:restaurant_justeat) do
    create :restaurant, name: "El Rancho #{rand(8)}",
                        slug: "el-rancho #{rand(8)}",
                        address: '1 Avenue Gabriel Péri, MONTREUIL 93100',
                        source: 'deliveroo'
  end
  let!(:restaurant_deliveroo) do
    create :restaurant, name: "El Paco #{rand(8)}",
                        slug: "el-paco #{rand(8)}",
                        address: '1 impasse de la Gaité, Paris, 75014',
                        source: 'deliveroo'
  end

  let!(:restaurant_foodin) do
    create :restaurant, name: "El Maco #{rand(8)}",
                        slug: "el-maco #{rand(8)}",
                        address: '1 Avenue du Dr Jean Mac, 72100 Le Mans, France',
                        source: 'foodin'
  end

  let!(:restaurant_restopolitain) do
    create :restaurant, name: "El Laco #{rand(8)}",
                        slug: "el-laco #{rand(8)}",
                        address: '1, place Jean Jaurès, 81100 Castres',
                        source: 'restopolitain'
  end

  context 'With an address from Justeat' do
    it 'Fill address columns cleanly' do
      FormatAddressesService.new(restaurant_justeat).call
      expect(restaurant_justeat.city).to eq 'Montreuil'
      expect(restaurant_justeat.zip_code).to eq '93100'
      expect(restaurant_justeat.street).to eq '1 Avenue Gabriel Péri'
      expect(restaurant_justeat.department).to eq 'Seine-Saint-Denis'
    end
  end

  context 'With an address from Deliveroo' do
    it 'Fill address columns cleanly' do
      FormatAddressesService.new(restaurant_deliveroo).call
      expect(restaurant_deliveroo.zip_code).to eq '75014'
      expect(restaurant_deliveroo.street).to eq '1 impasse de la Gaité'
      expect(restaurant_deliveroo.city).to eq 'Paris'
      expect(restaurant_deliveroo.department).to eq 'Paris'
    end
  end

  context 'With an address from Foodin' do
    it 'Fill address columns cleanly' do
      FormatAddressesService.new(restaurant_foodin).call
      expect(restaurant_foodin.zip_code).to eq '72100'
      expect(restaurant_foodin.street).to eq '1 Avenue du Dr Jean Mac'
      expect(restaurant_foodin.city).to eq 'Le Mans'
      expect(restaurant_foodin.department).to eq 'Sarthe'
    end
  end

  context 'With an address from Restopolitain' do
    it 'Fill address columns cleanly' do
      FormatAddressesService.new(restaurant_restopolitain).call
      expect(restaurant_restopolitain.zip_code).to eq '81100'
      expect(restaurant_restopolitain.street).to eq '1 place Jean Jaurès'
      expect(restaurant_restopolitain.city).to eq 'Castres'
      expect(restaurant_restopolitain.department).to eq 'Tarn'
    end
  end
end

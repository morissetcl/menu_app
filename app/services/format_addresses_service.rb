# frozen_string_literal: true

class FormatAddressesService
  attr_reader :restaurant, :address

  def initialize(restaurant)
    @restaurant = restaurant
    @address = restaurant.address
  end

  def call
    fill_fields
  end

  private

  def fill_fields
    return if restaurant.address.nil?
    return if need_to_be_update?

    if restaurant.from('foodin')
      fill_address_column_cleanly_foodin
    elsif restaurant.from('restopolitain')
      fill_address_column_cleanly_restopolitain
    else
      fill_address_column_cleanly
    end
  end

  def retrieve_city(zip_code)
    address_split = address.delete(zip_code).split(',')
    return address_split[-1] if restaurant.from('justeat')
    return address_split[1] if restaurant.from('deliveroo')

    ''
  end

  def update_restaurant(zip_code, city, street)
    department = DEPARTMENTS[zip_code.first(2)]
    restaurant.update(zip_code: zip_code, city: city,
                      street: street, department: department,
                      address: "#{street}, #{zip_code} #{city}")
  end

  def fill_address_column_cleanly_foodin
    address_split = address.split(',')
    zip_code = address_split[1].match(/(.*?)(\d+)/)[2]
    city = address_split[1].delete(zip_code)
    street = address_split.shift
    update_restaurant(zip_code, city.strip, street)
  end

  def fill_address_column_cleanly_restopolitain
    address_split = address.split(',')
    zip_code = address.scan(/(\d+)/).last.join
    city = address_split.last.split.last
    street = address_split.first(2).join
    update_restaurant(zip_code, city.strip, street)
  end

  def fill_address_column_cleanly
    zip_code = address.last(5).strip
    city = retrieve_city(zip_code).strip
    street = address.split(',')[0].strip
    update_restaurant(zip_code, city.capitalize, street)
  end

  def need_to_be_update?
    restaurant.zip_code_changed? ||
      restaurant.city_changed? ||
      restaurant.street_changed?
  end
end

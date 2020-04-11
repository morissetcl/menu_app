# frozen_string_literal: true

class FormatAddressesService
  class << self
    def call(restaurant)
      @restaurant = restaurant
      @source = restaurant.source
      @address = restaurant.address
      return if need_to_be_update?
      return if restaurant.address.nil?

      fill_fields
    end

    private

    def fill_fields
      if @source == 'foodin'
        fill_address_column_cleanly_foodin
      elsif @source == 'restopolitain'
        fill_address_column_cleanly_restopolitain
      elsif @source == 'restovisio'
        fill_address_column_cleanly_restovisio
      else
        fill_address_column_cleanly
      end
    end

    def retrieve_city(zip_code)
      address_split = @address.delete(zip_code).split(',')
      return address_split[-1] if @source == 'justeat'
      return address_split[1] if @source == 'deliveroo'

      ''
    end

    def fill_address_column_cleanly_foodin
      address_split = @address.split(',')
      zip_code = address_split[1].match(/(.*?)(\d+)/)[2]
      city = address_split[1].delete(zip_code)
      street = address_split.shift
      department = DEPARTMENTS[zip_code.first(2)]

      @restaurant.update(zip_code: zip_code, city: city.strip,
                         street: street, department: department,
                         address: "#{street}, #{zip_code} #{city.strip}")
    end

    def fill_address_column_cleanly_restopolitain
      address_split = @address.split(',')
      zip_code = address_split[2].match(/(.*?)(\d+)/)[2]
      city = address_split.last.split.last
      street = address_split.first(2).join.strip
      department = DEPARTMENTS[zip_code.first(2)]

      @restaurant.update(zip_code: zip_code, city: city.strip,
                         street: street, department: department,
                         address: "#{street}, #{zip_code} #{city.strip}")
    end

    def fill_address_column_cleanly_restovisio
      city = @address.split.last.strip
      zip_code = @address.chomp(city).split.last.strip
      street = @address.chomp(city).strip
      department = DEPARTMENTS[zip_code.first(2)]

      @restaurant.update(zip_code: zip_code, city: city,
                         street: street.chomp(zip_code).strip, department: department,
                         address: "#{street.chomp(zip_code).strip} #{zip_code} #{city.strip}")
    end

    def fill_address_column_cleanly
      zip_code = @address.last(5).strip
      city = retrieve_city(zip_code).strip
      street = @address.split(',')[0].strip
      department = DEPARTMENTS[zip_code.first(2)]

      @restaurant.update(zip_code: zip_code, city: city.capitalize,
                         street: street, department: department,
                         address: "#{street}, #{zip_code} #{city.capitalize}")
    end

    def need_to_be_update?
      restaurant = @restaurant
      restaurant.zip_code_changed? ||
        restaurant.city_changed? ||
        restaurant.street_changed?
    end
  end
end

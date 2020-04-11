# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { 'Super Resto' }
    slug { 'super-resto' }
    address { '2 place de Rouen 76000 Rouen' }
    source { 'unknow' }
  end
end

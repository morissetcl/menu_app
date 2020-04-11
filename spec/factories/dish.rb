# frozen_string_literal: true

FactoryBot.define do
  factory :dish do
    association :restaurant, factory: :restaurant
    title { 'Gratin dauphinois' }
    price { '10' }
    description { 'Pomme de terre with cheese' }
  end
end

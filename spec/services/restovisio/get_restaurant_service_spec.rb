# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe Restovisio::GetRestaurantService do
  ActiveJob::Base.queue_adapter = :test
  Sidekiq::Testing.fake!

  let(:url) { "#{Rails.root}/spec/support/files/restovisio/response_restaurant_menu.html" }
  let(:reponse_body) { File.open(url).read }

  let(:stub_restaurant_restovisio) do
    stub_request(:get, 'www.restovisio.com/restaurants/1.htm')
      .to_return(status: 200, body: reponse_body, headers: {})
  end
  before do
    stub_restaurant_restovisio
  end

  it 'Create a new restaurant and launch new worker' do
    expect do
      Restovisio::GetRestaurantService.call(1)
    end.to change(Restaurant, :count)
  end
end

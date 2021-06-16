# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    setup do
      Settings.openbill.categories.each_pair do |name, id|
        OpenbillCategory.create_with(name: name).find_or_create_by!(id: id)
      end

      # TODO: Make specific policies
      OpenbillPolicy.find_or_create_by(name: 'Allow all')
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

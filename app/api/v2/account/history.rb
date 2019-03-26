# encoding: UTF-8
# frozen_string_literal: true

require_relative '../validations'

module API
  module V2
    module Account
      class History < Grape::API

        # TODO: Check permissions

        desc 'Get your transactions and trades history.',
          is_array: true
          # success: API::V2::Entities::History

        params do
          optional :currency,
                   type: String,
                   values: { value: -> { Currency.enabled.codes(bothcase: true) }, message: 'account.currency.doesnt_exist' },
                   desc: 'Currency code'

          optional :filter,
                   type: String,
                   values: { value: ['trade', 'deposit+withdraw'], message: 'account.history.filter.invalid'},
                   desc: 'Param for filtering'

          optional :sort,
                   type: String,
                   values: { value: ['created_at'], message: 'account.history.sort.invalid' },
                   desc: 'Param for sorting'

          optional :order,
                   type: String,
                   values: { value: ['asc', 'desc'], message: 'account.history.order.invalid' },
                   desc: 'Sorting order'

        end
        get "/history" do
          currency = Currency.find(params[:currency]) if params[:currency].present?
          reference_types = params[:filter] ? params[:filter].split('+') : %w(trade deposit withdraw)


          liabilities = Operations::Liability.joins("LEFT JOIN revenues AS r ON r.reference_id = liabilities.reference_id AND r.reference_type = liabilities.reference_type")
                          .where(reference_type: reference_types, member_id: current_user.id)
                          .select('liabilities.id, r.id AS fee_id')

          liabilities
        end

      end
    end
  end
end

class ExchangesController < ApplicationController
  before_action :authenticate_user!

  def index
    @exchanges = Exchange.order(quotation_date: :desc).page params[:page]
  end

  def show
    @exchange = Exchange.find(params[:id])
  end

  def load_latest
    CurrenciesUpdater.perform_async
  end
end

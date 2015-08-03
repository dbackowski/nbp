class ExchangesController < ApplicationController
  before_action :authenticate_user!

  add_breadcrumb "Tabele kursów", :exchanges_path

  def index
    @exchanges = Exchange.order(quotation_date: :desc).page params[:page]
  end

  def show
    @exchange = Exchange.find(params[:id])
    add_breadcrumb @exchange.name, exchange_path(@exchange)
  end

  def load_latest
    CurrenciesUpdater.perform_async
  end
end

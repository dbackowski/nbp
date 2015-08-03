class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_years
  before_action :load_codes
  before_action :report_types

  add_breadcrumb 'Raporty', :reports_path

  def show
    @report = Report.where(code: @selected_code, year: @selected_year).order(month: :asc)

    respond_to do |format|
      format.html
      format.js
      format.json { render json: generate_json }
    end
  end

  private

  def load_years
    @years = Report.select('DISTINCT year').map(&:year)
    @selected_year = params[:year] || @years.max
  end

  def load_codes
    @codes = Report.select('DISTINCT code, converter').map { |a| ["#{a.converter} #{a.code}", a.code] }
    @selected_code = params[:code] || @codes.first
  end

  def report_types
    @types = { 'Tabela' => :table, 'Wykres' => :chart }
    @selected_type = params[:type] || @types.first
  end

  def generate_json
    series = [{ key: 'Średnia cena kupna', values: [] }, { key: 'Średnia cena sprzedaży', values: [] },
              { key: 'Mediana ceny kupna', values: [] }, { key: 'Mediana ceny sprzedaży', values: [] }]

    @report.each do |r|
      series[0][:values].push(x: r.month, y: r.avg_buy_price)
      series[1][:values].push(x: r.month, y: r.avg_sell_price)
      series[2][:values].push(x: r.month, y: r.median_buy_price)
      series[3][:values].push(x: r.month, y: r.median_sell_price)
    end

    series.to_json
  end
end

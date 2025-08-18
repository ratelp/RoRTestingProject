class DashboardController < ApplicationController
  before_action :authenticate_user!
  def index
    total_by_sale_by_day = Sale.group_by_day(:created_at, format: "%d/%b").sum(:total)

    @total_revenue, @total_sales = Sale.pluck(Arel.sql('COALESCE(SUM(total),0), COUNT(*)')).first
    @average_sale = @total_revenue/@total_sales

    @labels = total_by_sale_by_day.keys
    @data = total_by_sale_by_day.values
  end
end

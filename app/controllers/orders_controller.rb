class OrdersController < ApplicationController
  before_action :require_user!
  before_action :fetch_product


  def index
    @records = @product.orders
  end

  def new
    @record = @product.orders.build(record_params)
  end

  def create
    @record = @product.orders.build(record_params)
    unless params[:preview_before_save]
      redirect_to product_orders_path(@record.product) if @record.save!
    end
    @record
  end

  def show
  end

  def edit
  end
  
  private

  def fetch_product
    @supplier = current_supplier
    @product = @supplier.products.find_by(id: params[:product_id])
  end

  def record_params
    params.fetch(:order, {}).permit(:teacher_reference_number)
  end
end

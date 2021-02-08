class ProductsController < ApplicationController
  before_action :require_user!
  before_action :record, except: %i[index new create]

  def index
    if current_user.admin?
      @records = Product.all
    else
      @supplier = current_supplier
      @records = @supplier.products
    end
  end

  def show
  end

  def new
    @supplier = current_supplier
    @record = @supplier.products.build(record_params)
  end

  def create
    @supplier = current_supplier
    @record = @supplier.products.build({start_at: Date.today}.merge(record_params))
    unless params[:preview_before_save] # && @record.valid?
      redirect_to product_path(@record) if @record.save!
    end
    @record
  end

  def update
    @record.update({
      approved_at: Date.today,
      approved_by_id: @current_user.id
    })
    redirect_to product_path(@record)
  end

  def destroy
  end

  private

  def record
    @record ||= Product.find_by(id: params[:id])
  end

  def record_params
    params.fetch(:product, {}).permit(:name, :start_at, :price_pence, :quantity)
  end
end

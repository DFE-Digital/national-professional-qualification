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
    @record.approve! if @record.may_approve?
    redirect_to product_path(@record)
  end

  def start_programme
    @record.start! if @record.may_start?
    redirect_to product_path(@record)
  end

  def mid_way
    @record.mid_way! if @record.may_mid_way?
    redirect_to product_path(@record)
  end

  def complete_programme
    @record.complete! if @record.may_complete?
    redirect_to product_path(@record)
  end

  def destroy
  end

  private

  def record
    @record ||= Product.find_by(id: params[:id] || params[:product_id])
  end

  def record_params
    params.fetch(:product, {}).permit(:name, :start_at, :price_pence, :quantity)
  end
end

class ProductsController < ApplicationController
  before_action :require_user!
  before_action :record, except: [:index, :new, :create]

  def index
    @supplier = Supplier.first # TODO bind me to the current_user
    @records = @supplier.products
  end

  def show
  end

  def new
    @supplier = Supplier.first # TODO bind me to the current_user
    @record = @supplier.products.build
  end

  def create
    @supplier = Supplier.first # TODO bind me to the current_user
    @record = @supplier.products.build(record_params)
    unless params[:preview_before_save] # && @record.valid?
      if @record.save!
        redirect_to product_path(@record)
      end
    end
    @record
  end

  def update
  end

  def destroy
  end

  private

  def record
    @record ||= Product.find_by(id: params[:id])
  end

  def record_params
    params.require(:product).permit(:name, :start_at, :price_pence, :quantity)
  end
end

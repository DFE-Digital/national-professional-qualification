class SuppliersController < ApplicationController
  before_action :require_user!
  def index
    @records = Supplier.all
  end

  def show
    @record = Supplier.find_by(id: params[:id])
  end

  def new
    @record = Supplier.new
  end

  def create
    @record = Supplier.new(record_params)
    unless params[:preview_before_save] # && @record.valid?
      if @record.save!
        redirect_to supplier_path(@record)
      end
    end
  end

  private

  def record_params
    params.require(:supplier).permit(:name)
  end
end

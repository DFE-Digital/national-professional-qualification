class SuppliersController < ApplicationController
  before_action :require_user!
  def index
    @records = Supplier.all
  end

  def show
    @record = Supplier.find_by(id: params[:id])
  end

  def new
    @record = Supplier.new(record_params)
    if @record.supplier_members.size.zero?
      @record.supplier_members.build.build_user(role: "supplier")
    end
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
    params.fetch(:supplier, {}).permit(
      :name,
      :unique_reference_number,
      supplier_members_attributes: [
        user_attributes: [:email]
      ]
    )
  end
end

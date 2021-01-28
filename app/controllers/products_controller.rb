class ProductsController < ApplicationController
  before_action :record, except: [:index, :new, :create]

  def index
  end

  def show
  end

  def new
    @record = Product.new(params)
  end

  def create
    @record = Product.new(params)
    @record.save if @record.valid?
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
end

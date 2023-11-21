class StylesController < ApplicationController
  before_action :set_style, only: %i[show edit update destroy]

  def new
    @style = Style.new
  end

  def index
    @styles = Style.all
  end

  def show
  end

  def edit
  end

  def create
    @style = Style.new(style_params)

    respond_to do |format|
      if @style.save
        format.html { redirect_to styles_path, notice: "Style was successfully created." }
        format.json { render :show, status: :created, location: @style }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @style.update(style_params)
        format.html { redirect_to style_url(@style), notice: "Style was successfully updated." }
        format.json { render :show, status: :ok, location: @Style }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @style.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if !admin_user
      return redirect_to style_url(@style), notice: "Destroy possible only for admin."
    end

    @style.destroy

    respond_to do |format|
      format.html { redirect_to styles_url, notice: "Style was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def set_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end
end

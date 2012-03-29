class DocumentationController < ApplicationController

  before_filter :load_sections

  def index
    @recommended = DocumentationPage.live.recommended.by_position
  end

  def new
    @doc = DocumentationPage.new
  end

  def create
    @doc = DocumentationPage.new(params[:documentation_page])
    if @doc.save
      redirect_to :action => :show, :id => @doc.friendly_id
    else
      render :new
    end
  end

  def show
    @page = DocumentationPage.find(params[:id])
  end

  def edit
    @doc = DocumentationPage.find(params[:id])
  end

  def update
    @doc = DocumentationPage.find(params[:id])
    if @doc.update_attributes(params[:documentation_page])
      redirect_to :action => :show, :id => @doc.friendly_id
    else
      render :edit
    end
  end

  def search
    @terms = params[:documentation][:terms]
    available_pages = (current_developer and current_developer.admin?) ? DocumentationPage : DocumentationPage.live
    @results = available_pages.where("markdown LIKE ?", "%#{@terms}%")
  end

  private

  def load_sections
    @sections    = DocumentationSection.live
  end


end

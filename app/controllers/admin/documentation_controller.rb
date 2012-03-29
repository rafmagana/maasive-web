class Admin::DocumentationController < Admin::ApplicationController

  before_filter :load_sections
  

  def index
    @docs = DocumentationPage.all
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
  
  def installers
  end
  
  private
  
  def load_sections
    @sections    = DocumentationSection.all
  end


end

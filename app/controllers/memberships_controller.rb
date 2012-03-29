class MembershipsController < ApplicationController
  
  before_filter :authenticate_developer!
  before_filter :load_account
  add_breadcrumb "Dashboard", :root_path
  
  def index
    @memberships = @account.memberships
  end
  
  def new
    @membership = @account.memberships.build
  end
  
  def create
    @membership = @account.memberships.build(params[:membership])
    @developer  = Developer.find_by_email(params[:membership][:email])
    unless @developer
      @membership.errors.add_to_base("There is no user with the email #{params[:membership][:email]}.")
      render :new
    else
      @membership.developer = @developer
      if @membership.save
        redirect_to :action => :index
      else
        render :new
      end
    end
  end
  
  def destroy
    @membership = @account.memberships.find(params[:id])
    unless @account.memberships.count == 1
      if @membership.destroy
        flash[:notice] = "Membership deleted"
        redirect_to :action => :index
      else
        flash[:notice] = "Membership could not be deleted"
        redirect_to :action => :index
      end
    else
      flash[:alert] = "You can not delete the last developer on an Account"
      redirect_to :action => :index
    end
  end
  
  private
  
  def load_account
    @account = Account.find(params[:account_id])
  end
  
end
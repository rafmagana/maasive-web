class Admin::MongosController < Admin::ApplicationController
  
  def show
    @stats = MongoMapper.database.command({:serverStatus => true})
  end
  
end

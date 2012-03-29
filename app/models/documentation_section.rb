class DocumentationSection < ActiveRecord::Base
  
  has_many :documentation_pages
  
  scope :live, { :conditions => "EXISTS (SELECT 1 FROM documentation_pages where documentation_pages.live = 1 && documentation_sections.id = documentation_pages.documentation_section_id)"}

end

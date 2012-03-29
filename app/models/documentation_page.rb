class DocumentationPage < ActiveRecord::Base
  has_friendly_id :title, :use_slug => true

  belongs_to :documentation_section

  attr_accessor :section_title

  before_save :ensure_section

  scope :recommended, :conditions => {:recommended => true}
  scope :by_position, :order => "position ASC"
  scope :live, :conditions => {:live => true}

  def ensure_section
    existing = DocumentationSection.find(:first, :conditions => ["lower(title) = ?", self.section_title.downcase])
    return self.documentation_section = existing if existing
    self.documentation_section = DocumentationSection.create(:title => self.section_title)
  end

  def section_title
    @section_title || self.documentation_section.try(:title)
  end

end

module EndpointHelper
  
  def endpoint_path(app, api_table)
    "/apps/#{app.identifier}/versions/#{api_table.version_hash}/#{api_table.name}"
  end
  
  def page_links_for(instances)
    max_links = 14
    
    count   = [instances.total_pages, max_links].min
    min     = [instances.current_page - (count / 2), 1].max
    
    used = instances.current_page - min
    
    max     = [instances.total_pages,  instances.current_page+(count - used)].min
        
    Range.new(min, max).to_a.map do |i|
      if i == instances.current_page
        "#{i}"
      else
        link_to i, "?page=#{i}"
      end
    end.join(' ').html_safe
  end
  
  def options_for_versions(api_tables)
    api_tables.map do |a|
      "<options value='#{endpoint_path(current_app, a)}'> #{a.version_hash} </option>"
    end.join('').html_safe
  end
  
  def select_tag_for_schema(label, type)
    case type
    when "Integer"
    when "Float"
      [select_tag("#{label}_operator", "<option value='eql'>equals</option><option value='gt'>greater then</option><option value='lt'>less then</option>".html_safe),
       text_field_tag("#{label}_value")].join(' ').html_safe
    when "Boolean"
      [select_tag("#{label}_operator", "<option value='eql'>is</option><option value='ne'>is not</option>".html_safe),
       select_tag("#{label}_value", "<option value='true'>true</option><option value='false'>false</option>".html_safe)].join(' ').html_safe
    when "EncryptedString"
       [select_tag("#{label}_operator", "<option value='eql'>equals</option><option value='ne'>not equal</option>".html_safe),
       text_field_tag("#{label}_value"),
       check_box_tag("#{label}_unencrypted", nil, nil, :'data-ai' => current_app.identifier, :'data-sk' => current_app.secret_key), label_tag("value is unencrypted")].join(' ').html_safe
    else
      [select_tag("#{label}_operator", "<option value='eql'>equals</option><option value='ne'>not equal</option>".html_safe),
       text_field_tag("#{label}_value")].join(' ').html_safe
    end
  end
  
end

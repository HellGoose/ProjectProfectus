module EnableElementHelper
  def enable_element_by_id(id)
		page.execute_script("$('#"+id+"').removeAttr('disabled')")
  end
end
module ApplicationHelper
  def section_path_for(section)
    section.key == "today" ? root_path : public_send(:"#{section.key}_path")
  end

  def current_section?(section)
    @section == section
  end

  def page_title
    [ content_for(:title), "Prayerbook Atlas" ].compact_blank.join(" · ")
  end
end

module ApplicationHelper
  def options_for_video_rating(selected=nil)
    options_for_select(5.downto(1).to_a.map {|i| [pluralize(i, 'Star'), i]}, selected)
  end
end

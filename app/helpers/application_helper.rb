module ApplicationHelper

  def full_title(page_title)
    base_title = "TransHousing"
    if page_title.blank?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def icon(class_str)
    icon_class = "."+class_str.strip.split(" ").join(".")
    raw Haml::Engine.new("%i#{icon_class}").render.chop
  end

  def gender_category(user_gender_identity)
    if user_gender_identity.to_s.downcase != "male" &&
       user_gender_identity.to_s.downcase != "female"
      "nb"
    else
      user_gender_identity.to_s.downcase
    end
  end

  def gender_category_class
    "header-username-#{gender_category(current_user.gender[:identity])}"
  end
end

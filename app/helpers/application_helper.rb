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

  def checkbox_group(options)
    # options hash must include :collection, :ul_class, and :html_name
    @ul = options
    render "shared/checkbox_group"
  end

  def select_given_options(options)
    @options = options
    render "shared/select_given_options"
  end

  def select_numerical_given_options(options)
    @options = options
    render "shared/select_numerical"
  end


  def get_stars(rating)
    counter = 0
    stars = "&nbsp"
    while rating > 0.67 do
      stars += '<i class="fa fa-star" fa-lg></i>'
      counter = counter + 1
      rating = rating - 1
    end
    if rating > 0.33
      stars += '<i class="fa fa-star-half-o" fa-lg></i>'
      counter = counter + 1
    end
      while counter< 5 do
      stars += '<i class="fa fa-star-o" fa-lg></i>'
      counter = counter + 1
    end
    stars.html_safe
  end


end

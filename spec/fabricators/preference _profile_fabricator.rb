Fabricator(:preference_profile) do
  message_notifs        { Hash[:text,  [true,false].sample,
                               :email, [true,false].sample] }
  dashboard_notifs      { Hash[:text,  [true,false].sample,
                               :email, [true,false].sample] }
end

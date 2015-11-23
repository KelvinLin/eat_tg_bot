class SystemSettings < Settingslogic
  source "#{Rails.root}/config/system.yml"
  namespace Rails.env
end


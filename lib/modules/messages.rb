module Modules
  module Messages
    def success_flash_message(type, text)
      flash[type] ||= []
      flash[type] << text
    end

    def error_flash_message(type, text)
      flash[type] ||= []
      flash[type] << text
    end
  end
end

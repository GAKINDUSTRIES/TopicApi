class NotificationService
  def self.notify(push_tokens, message, data)
    params = {
      app_id: ENV['APP_ID'],
      contents: {
        en: message
      },
      data: data,
      include_player_ids: push_tokens
    }
    begin
      OneSignal::Notification.create(params: params)
    rescue OneSignal::OneSignalError => exception
      Rails.logger.info(exception)
    end
  end
end

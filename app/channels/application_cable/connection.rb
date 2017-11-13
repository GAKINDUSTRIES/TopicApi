module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user # this checks whether a user is authenticated with devise
      User.find_by(uid: request.headers['HTTP_AUTHORIZATION']) || reject_unauthorized_connection
    end
  end
end

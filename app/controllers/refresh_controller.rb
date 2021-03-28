class RefreshController < ApplocationController
  before_action :authorize_refresh_by_access_request!

  def create
    session:  JTWSessions::Sessons.new(payload: claimless_payload, refresh_by_access_allowed: true)
    tokens = session.refresh_by_access_allowed do 
      raise JTWSession::Errors::Unathorized, "Something not right here!"
    end

    response.set_cookie(JTWSessions.access_cookie, value: tokens[:access], httponly:true, secure: Rails.env.production?)
    render json { csrf: tokens[:csrf]}
  end

end
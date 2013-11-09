OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, "389488077848048", "7f147e52daa71e0372f70a389b6e7647"
end

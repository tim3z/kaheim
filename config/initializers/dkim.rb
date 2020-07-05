if Rails.env.production?
  Dkim::domain      = 'kaheim.de'
  Dkim::selector    = 'mail'
  Dkim::private_key = open('/home/kaheim7/dkim/kaheim.de.2020-06.private').read

  ActionMailer::Base.register_interceptor(Dkim::Interceptor)
end

if Rails.env.production?
  Dkim::domain      = 'kaheim.de'
  Dkim::selector    = '20200605'
  Dkim::private_key = open('/home/kaheim7/dkim/20200605.private').read

  ActionMailer::Base.register_interceptor(Dkim::Interceptor)
end

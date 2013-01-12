class RegistrationsController < Devise::RegistrationsController

  def create
    #if verify_recaptcha
      super
    #else
    #  build_resource
    #  clean_up_passwords(resource)
    #  flash[:alert] = t 'recaptcha.errors.verification_failed'
    #  render 'new'
    #end
  end
end

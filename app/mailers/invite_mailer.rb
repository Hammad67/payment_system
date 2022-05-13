class InviteMailer < ApplicationMailer
    def welcome_mail
      @password=params[:password]
      @user= params[:usermail]
  
      mail(to: @user.email,subject: "Payment System!")
      
    end

end

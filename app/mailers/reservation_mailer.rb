class ReservationMailer < ApplicationMailer
    def client_email(customer)
        @user = customer
        @subject = "You'vve made a reservation"
        mail(to: @user.email, subject: @subject)
    end
    
    def host_email(host)
        @host = host
        @subject = "Someone has made a reservation on your listing!"
        mail(to: @host.email, subject: @subject)
    end
end

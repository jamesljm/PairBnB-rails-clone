class ReservationMailer < ApplicationMailer
    def booking_email(customer, host, reservation_id)
        @user = customer
        @host = host

        @user_subject = "You'vve made a reservation"
        @host_subject = "Someone has made a reservation on your listing!"

        mail(to: @host.email, subject: @subject)
        mail(to: @user.email, subject: @subject)
    end
end

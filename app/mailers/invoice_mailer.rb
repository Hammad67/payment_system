# frozen_string_literal: true

# used for sending invoice
class InvoiceMailer < ApplicationMailer
  def invoicemail
    @usermail = params[:usermail]
    @invoice_pdf = params[:invoice]

    mail(to: @usermail, subject: 'Here is your invoice!')
  end
end

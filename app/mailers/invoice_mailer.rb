# frozen_string_literal: true

class InvoiceMailer < ApplicationMailer
  def invoicemail
    @usermail = params[:usermail]
    @invoice_pdf = params[:invoice]

    mail(to: @usermail, subject: 'Here is your invoice!')
  end
end

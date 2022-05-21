class InvoiceMailer < ApplicationMailer
  def invoicemail
    @usermail = params[:usermail]
    @invoice_pdf = params[:invoice_pdf]

    mail(to: @usermail, subject: 'Here is your invoice!')
  end
end

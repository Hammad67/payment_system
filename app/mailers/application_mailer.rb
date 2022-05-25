# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'hammad.rashid@devsinc.com'
  layout 'mailer'
end

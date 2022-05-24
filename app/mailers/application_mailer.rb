# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV('EMAIL').to_s
  layout 'mailer'
end

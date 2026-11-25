class BugReminderJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 1.minute, attempts: 3

  def perform(bug)
    email_key = "bug_reminder_#{bug.id}"

    email_log = EmailLog.find_or_initialize_by(email_key: email_key)

    return if email_log.status_sent?

    email_log.assign_attributes(
      bug: bug,
      recipient_email: bug.developer.email,
      subject: "Please acknowledge your assigned bug",
      status: :pending
    )

    email_log.save!

    begin
      BugMailer.reminder(bug).deliver_now

      email_log.update!(
        status: :sent,
        sent_at: Time.current
      )
    rescue StandardError
      email_log.update!(status: :failed)
      raise
    end
  end
end
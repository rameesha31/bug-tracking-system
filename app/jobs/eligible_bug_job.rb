class EligibleBugJob < ApplicationJob
    queue_as :default
  
    def perform
        bugs = Bug.where(
            status: :new_bug,
            acknowledged: false,
          ).where("created_at <= ?", 24.hours.ago)
           .where.not(assigned_to_id: nil)
      
        bugs.find_each do |bug|
            BugReminderJob.perform_later(bug)
            puts "Reminder job enqueued for Bug ##{bug.id}"
        end
    end
end
  
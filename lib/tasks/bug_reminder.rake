namespace :bug_reminder do
    desc "Send reminders for old unacknowledged bugs"

    task send: :environment do
        bugs = Bug.where(description: nil)
        bugs.find_each do |bug|
          bug.update(description: "testing")
        end
    end
end

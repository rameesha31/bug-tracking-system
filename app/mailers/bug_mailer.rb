class BugMailer < ApplicationMailer
    default from: "rameeshashafiq73@gmail.com"

    def reminder(bug)
        @bug = bug 
        mail(
            to: @bug.developer.email,
            subject: "Please acknowledge your assigned bug"
        )
    end 
end

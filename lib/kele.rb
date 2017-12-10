require 'httparty'
require 'json'
require 'roadmap.rb'

class Kele
    include HTTParty
    include Roadmap
    
    def initialize(email, password)
        response = self.class.post("https://www.bloc.io/api/v1/sessions", body: {"email": email, "password": password})
        raise 'Invalid email and/or password' if response.code == 404
        @auth_token = response['auth_token']    
    end
    
    def get_me
        response = self.class.get("https://www.bloc.io/api/v1/users/me", headers: { "authorization" => @auth_token })
        @user_data = JSON.parse(response.body)
    end
    
    def get_mentor_availability(mentor_id)
        response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token })
        @mentor_availability = JSON.parse(response.body)
    end 
    
    def get_messages(page_number = nil)
        if page_number == nil
            response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token })
        else
            response = self.class.get("https://www.bloc.io/api/v1/message_threads?page=#{page_number}", headers: { "authorization" => @auth_token })
        end    
        @messages = JSON.parse(response.body)
    end
    
    def create_messages(user_id, recipient_id, token=nil, subject, content)
        self.class.post('https://www.bloc.io/api/v1/messages', 
            body:  {
                'user_id': user_id,
                'recipient_id': recipient_id,
                'token': token,
                'subject': subject,
                'stripped-text': content
            },
            headers: { "authorization" => @auth_token }
        )
    end
    
    def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
        self.class.post('https://www.bloc.io/api/v1/checkpoint_submissions',
            body: {
                'checkpoint_id': checkpoint_id,
                'assignment_branch': assignment_branch,
                'assignment_commit_link': assignment_commit_link,
                'comment': comment,
                'enrollment_id': enrollment_id
            },
            headers: { "authorization" => @auth_token }
        )
    end    
end
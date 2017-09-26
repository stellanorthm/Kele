require "Kele/version"
require 'json'
require 'roadmap'

module Kele

  include HTTParty
  #base_uri "https://www.bloc.io/api/v1/"

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: { "email": email, "password": password })
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body)
    @user_data
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body)
    @mentor_availability
  end

  def get_messages(page = 1)
   response = self.class.get(api_url("message_threads"), values: {"page": page} , headers: { "authorization" => @auth_token })
   @messages = JSON.parse(response.body)
   return @messages
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    response = self.class.post(api_url("checkpoint_submissions"), body: { "checkpoint_id": checkpoint_id, "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "comment": comment }, headers: { "authorization" => @auth_token })
    return response
  end

private

  def api_url(end_point)
     "https://www.bloc.io/api/v1/#{end_point}"
   end

end

require 'octokit'

class Webhooks::WebhooksController < ApplicationController
  # repo_name => review_group_slug
  GROUPS = {
    'random-pr-reviewer-from-group' => 'test'
  }.freeze

  def pull_request
    data = JSON.parse(params["payload"])

    return unless data["action"] == "review_requested"

    repo_name = data["pull_request"]["base"]["repo"]["name"]
    team_slug = GROUPS[repo_name]

    review_team = data["pull_request"]["requested_teams"].find { |team| team["slug"] == team_slug }

    return unless review_team.present?

    # Don't tag anyone else if there's already a person tagged on the PR.
    # This prevents an infinite loop of tagging, and if someone tagged someone specifically we
    # probably don't need another reviewer.
    return unless data["pull_request"]["requested_reviewers"].count == 0

    client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])

    team_members = client.team_members(review_team["id"])

    # Don't try to tag the author of the PR.
    filtered_team_members = team_members.reject { |member| member.login == data["pull_request"]["user"]["login"] }

    reviewer = filtered_team_members.sample.login

    repo_id = data["repository"]["id"]
    pr_number = data["number"]
    client.request_pull_request_review(repo_id, pr_number, {reviewers: [reviewer]})
  end
end

class Batch::AutoUpdateContribution
  def self.auto_update_contribution
    @users = User.all
    @users.each do |user|
      github_name = '"' + user.name + '"'
      uri = URI.parse("https://api.github.com/graphql")
      request = Net::HTTP::Post.new(uri)
      request["Authorization"] = ENV['GITHUB_API']
      request.body = JSON.dump({"query" => "query {user (login: #{github_name}) {contributionsCollection {contributionCalendar {totalContributions}}}}"})
      req_options = {
        use_ssl: uri.scheme == "https"
      }
      response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
      end
      if response.body.include?("error")
        user.contributions = 0
      else
        user.contributions = response.body.gsub(/[^\d]/, "").to_i
      end
      user.update(contributions: user.contributions)
    end
    p "全てのコントリビューションをアップデートしました。"
  end
end
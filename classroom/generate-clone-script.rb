require 'rubygems'
require 'bundler/setup'
require 'octokit'

REPO = 'pvm1718'


token = IO.read('token.secret').strip
G = github = Octokit::Client.new(:access_token => token, per_page: 150)

github.organization_repositories(REPO).each do |repo|
    url = repo.clone_url
    /^exercises-(.*)$/ =~ repo.name or abort "Could not parse #{repo.name}"
    name = $1
    puts <<-END
if [ ! -d #{name} ]; then
    git clone #{url} #{name}
else
    (cd #{name}; git pull --no-edit)
fi
    END
end

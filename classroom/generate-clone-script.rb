require 'rubygems'
require 'bundler/setup'
require 'octokit'

REPO = 'ucll-vgo1920-sem1'
PROJECT = 'picross'

token = IO.read('token.secret').strip
G = github = Octokit::Client.new(:access_token => token, per_page: 150)

github.organization_repositories(REPO).each do |repo|
    url = repo.clone_url
    /^#{PROJECT}-(.*)$/ =~ repo.name or abort "Could not parse #{repo.name}"
    name = $1
    puts <<~END
        if [ ! -d #{name} ]; then
            git clone #{url} #{name}
        else
            (cd #{name}; git pull --no-edit)
        fi
    END
end

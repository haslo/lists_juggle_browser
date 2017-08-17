class NewsController < ApplicationController

  def index
    changelog       = File.read(Rails.root + 'CHANGELOG.md')
    markdown        = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @html_changelog = markdown.render(changelog)
  end

end

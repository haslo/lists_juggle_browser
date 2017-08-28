class AboutsController < ApplicationController

  def show
    about       = File.read(Rails.root + 'ABOUT.md')
    markdown    = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
    @html_about = markdown.render(about)
  end

end

# app/helpers/lessons_helper.rb
module LessonsHelper
  def highlight_prism(content)
    doc = Nokogiri::HTML.fragment(content)
    doc.css('pre code').each do |code_block|
      code_block.inner_html = CGI.escapeHTML(code_block.inner_html)
    end
    doc.to_s
  end
end

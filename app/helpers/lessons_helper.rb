  # app/helpers/lessons_helper.rb
  module LessonsHelper
    def highlight_prism(content)
      # Utiliza Nokogiri para parsear el contenido
      doc = Nokogiri::HTML::DocumentFragment.parse(content)
      doc.css('pre code').each do |code_block|
        # Escapa explícitamente las etiquetas HTML dentro de los bloques de código
        escaped_html = CGI.escapeHTML(code_block.inner_html)
        code_block.inner_html = escaped_html
      end
      # Devolver el contenido marcado como seguro para HTML
      doc.to_html.html_safe
    end
  end

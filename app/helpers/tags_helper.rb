module Merb
    module TagsHelper
      def highlight(text, phrase)
        if text.blank? || phrase.blank?
          text
        else
          match = Array(phrase).map { |p| Regexp.escape(p) }.join('|')
          text.gsub(/(#{match})/i, '<strong class="highlight">\1</strong>')
        end
      end
    end
end
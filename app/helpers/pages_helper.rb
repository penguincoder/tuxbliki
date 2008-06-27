module Merb
    module PagesHelper
      def edit_page_link(page)
        "<a href='#{url(:page, :id => page.name.gsub(/ /, '_'))}' title='#{h(page.name)}'>#{h(page.name)}</a>"
      end
    end
end
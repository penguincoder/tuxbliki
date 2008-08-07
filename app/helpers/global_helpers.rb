module Merb
  module GlobalHelpers
    def nl2br(str)
      str.gsub(/\n/, '<br />')
    end
    
    def error_messages_for(obj)
      obj = instance_variable_get("@#{obj.to_s}") if obj.is_a?(Symbol)
      return nil if obj.errors.nil? or obj.errors.empty?
      res = []
      res << "<br /><div id='errorExplanation'>"
      res << "<p>The following errors prevented the model from being saved:</p>"
      res << "<ol>"
      obj.errors.each_full do |msg|
        res << "<li>#{msg}</li>"
      end
      res << "</ol>"
      res << "</div>"
      res << "<br />"
      res.join
    end
    
    def show_page_description(page)
      page_cache = Cache.get(page.cache_name)
      if page_cache.nil?
        desc = h(page.description.to_s).to_s.gsub(/\&quot\;/, '"').gsub(/\&amp\;/, '&')
        # i need pre/code block together... because i code :)
        desc.gsub!("&lt;pre&gt;&lt;code&gt;", "<pre><code>")
        desc.gsub!("&lt;/code&gt;&lt;/pre&gt;", "</code></pre>")
        rc = RedCloth.new(desc)
        rc.no_span_caps = true
        rc.filter_styles = true
        rc.filter_html = true
        page_cache = rc.to_html.gsub(Page.wiki_word_pattern) do |match|
          pg_name = $1
          if Page.exists?(pg_name)
            "<a class='wiki_link' style='color: #00F;' href='#{url(:page, pg_name.gsub(/ /, '_'))}'>#{pg_name}</a>"
          else
            "<a class='missing_wiki_link' rel='nofollow' style='color: #00F;' href='#{url(:new_page, :new_name => pg_name.gsub(/ /, '_'))}'>#{pg_name}</a>?"
          end
        end
        Cache.put(page.cache_name, page_cache)
      end
      page_cache
    end
    
    def show_page_link(page)
      "<a href='#{url(:page, :id => page.name.gsub(/ /, '_'))}'>#{page.name}</a>"
    end
    
    def tag_cloud(tags)
      max = 0
      tags.each { |tag| max = tag.count.to_i if tag.count.to_i > max }
      min = max
      tags.each { |tag| min = tag.count.to_i if tag.count.to_i < min }
      divisor = ((max - min) / tag_cloud_styles.size) + 1
      tags.collect { |t| "<span class='#{tag_cloud_styles[(t.count.to_i - min) / divisor]}'><a href='#{url(:tag, :id => t.name)}'>#{t.name}</a></span>" }.join(' ')
    end
    
    def tag_cloud_styles
      %w(tag_cloud_1 tag_cloud_2 tag_cloud_3 tag_cloud_4 tag_cloud_5 tag_cloud_6 tag_cloud_7 tag_cloud_8 tag_cloud_9 tag_cloud_10 tag_cloud_11 tag_cloud_12)
    end
    
    def allowed_to?(name, obj = nil)
      return false if session[:author_id].nil?
      @author_for_permissions ||= Author.find(session[:author_id])
      has_base = Permission.author_has_permission_to?(name, @author_for_permissions)
      if obj and obj.respond_to?('author_id') and obj.author_id != session[:author_id]
        has_base and Permission.author_has_permission_to?("any_#{name}", @author_for_permissions)
      else
        has_base
      end
    end
    
    def block_to_partial(partial_name, options = {}, &block)
      options.merge!(:body => capture(&block))
      concat(partial(partial_name, :locals => options), block.binding)
    end
    
    def photo_url(photo)
      "/photos/#{photo.id}/#{photo.filename}"
    end
    
    def screen_photo_url(photo)
      url(:controller => 'photos', :action => 'screen', :id => photo.id)
    end
    
    def thumbnail_photo_url(photo)
      url(:controller => 'photos', :action => 'thumbnail', :id => photo.id)
    end
    
    def indicator
      "<img src='/images/ajax-loader.gif' id='indicator' alt='indicator' style='display: none;' />"
    end
    
    def tuxconfig
      Merb::Plugins.config[:tuxbliki]
    end
  end
end

#!/bin/bash
# must be run from Merb.root
merb -i << EOF
a = Author.find :first

ActiveRecord::Base.establish_connection({
  :adapter => 'mysql',
  :username => 'andrew',
  :socket => '/var/lib/mysql/mysql.sock',
  :database => 'drupal'
})

nodes = ActiveRecord::Base.connection.execute("SELECT * FROM node")
comments = ActiveRecord::Base.connection.execute("SELECT * FROM comments")
#ActiveRecord::Base.connection.execute("DELETE FROM files WHERE filename = 'thumbnail' OR filename = 'preview'")
#files = ActiveRecord::Base.connection.execute("SELECT * FROM files")

ActiveRecord::Base.connection.disconnect!
ActiveRecord::Base.establish_connection(YAML::load_file('config/database.yml')[:development])

pages = []
nodes.each_hash do |node|
  next unless node['type'] == 'blog'
  c = Time.now
  c -= (c.to_i - node['created'].to_i).seconds
  [
    [ /<\/?em>/, '_' ],
    [ /<\/?strong>/, '*' ],
    [ /<blockquote>/, 'bq.' ],
    [ /<\/blockquote>/, '' ],
    [ /<\/?strike>/, '-' ],
    [ /<\/?sup>/, '^' ],
    [ /<\/?sub>/, '~' ],
    [ /<\/?pre>/, '' ],
    [ /<\/?code>/, '@' ],
    [ /<br ?\/?>/, "\n" ],
    [ /<\/?[ou]l>/, '' ],
    [ /<li>/, '* ' ],
    [ /<\/li>/, '' ],
    [ /\&amp\;/, '&' ]
  ].each do |regexp|
    node['body'].gsub!(regexp.first, regexp.last)
  end
  node['body'].gsub!(/<a.+href=['"]([^"']+)["'].*>(.+)<\/a>/) do |match|
    "\"#{\$2}\":#{\$1}"
  end
  p = Page.new :name => node['title'].gsub(/[^A-Za-z0-9 ]/, ''), :created_at => c, :description => node['body'], :published => true, :nid => node['nid']
  p.author_id = a.id
  pages << p
end

pages.each do |p|
  p.save
  if p.new_record?
    \$stderr.puts "FAILED TO SAVE PAGE #{p.name} #{p.nid}"
    p.errors.each_full { |msg| \$stderr.puts "* #{msg}" }
    next
  else
    puts "Saved page #{p.id} for node #{p.nid}"
  end
  comments.data_seek(0)
  comments.each_hash do |comment|
    next unless comment['nid'].to_i == p.nid.to_i
    c2 = Time.now
    c2 -= (c2.to_i - comment['timestamp'].to_i).seconds
    c = Comment.create(:comment => comment['comment'], :user => comment['name'], :url => comment['homepage'], :created_at => c2, :page_id => p.id)
    if c.new_record?
      \$stderr.puts "FAILED TO SAVE COMMENT ON PAGE #{p.id} NODE #{p.nid}"
      c.errors.each_full { |msg| \$stderr.puts "* #{msg}" }
    else
      puts "Saved comment id #{c.id} for page #{p.id} node #{p.nid}"
    end
  end
end.size

EOF

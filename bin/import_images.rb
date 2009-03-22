#!/usr/bin/env ruby
#
# TuxBliki image file importer. Use locally, saves remotely.
#
# == Synopsis
#
# Automatically creates the album if not found, so no worries there. Requires
# ImageMagick's `convert` program to function. Also automatically resizes images
# to a maxiumum of 1280 x 1280. Parameters are required unless otherwise noted.
# Also uses `identify` to determine if resizing is required.
#
# == Usage
#
# ./bin/import_images.rb <options>
#
# --help, -h
#   This help message.
#
# --file <filename>
#   The image you are going to upload. Must not be in /tmp for conversion.
#
# --directory <directory>
#   The directory of images to upload.
#
# --album <album_name>
#   The name of the Album to import the file into.
#
# --username <username>
#   The username in TuxBliki to use as the owner.
#
# --server <server address>
#   The server running TuxBliki, optional; defaults to http://penguincoder.org
#
# --port <server port>
#   The port to use, optional; defaults to 80.
#
require 'rdoc/usage'
require 'getoptlong'
require 'mechanize'
require 'uri'

opts = GetoptLong.new(
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--file', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--directory', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--album', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--username', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--password', GetoptLong::REQUIRED_ARGUMENT ],
  [ '--server', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--port', GetoptLong::OPTIONAL_ARGUMENT ]
)

filename = nil
directory = nil
album = nil
username = nil
password = nil
server = 'http://penguincoder.org'
port = 80

opts.each do |opt, arg|
  case opt
    when '--file'
      filename = arg
    when '--directory'
      directory = arg.gsub(/\/$/, '')
    when '--album'
      album = arg
    when '--username'
      username = arg
    when '--password'
      password = arg
    when '--server'
      server = arg
    when '--port'
      port = arg.to_i
  end
end

# process argument sanity
if filename.nil? and directory.nil?
  RDoc::usage
  exit 1
elsif album.nil?
  RDoc::usage
  exit 1
elsif filename and !File.readable?(filename)
  puts "File is not readable!"
  exit 1
elsif directory and !File.directory?(directory)
  puts "Directory is not a directory!"
  exit 1
end

# build request
agent = WWW::Mechanize.new
host_prefix = "#{server.gsub(/\/$/, '')}:#{port}"

# log into the software first
page = agent.get("#{host_prefix}/sessions/new")
login_form = page.forms.first
login_form.username = username
print "Password: "
STDOUT.flush
system "stty -echo"
password = STDIN.readline.chomp
system "stty echo"
puts ''
login_form.password = password
page = agent.submit(login_form, login_form.buttons.first)

# redirected back, so it is a failure
if page.uri.to_s =~ /sessions/
  puts "Login failed!"
  exit 1
else
  puts "* Successfully logged in as '#{username}'"
end

# make sure the album is there, create it otherwise...
begin
  page = agent.get("#{host_prefix}/albums/#{album.gsub(/ /, '_')}")
  puts "* Found the album '#{album}'"
rescue WWW::Mechanize::ResponseCodeError => exception
  if exception.response_code.to_i == 404
    puts "Album does not exist, creating it!"
    page = agent.get("#{host_prefix}/albums/new")
    album_form = page.forms.first
    album_form['album[name]'] = album
    page = agent.submit(album_form, album_form.buttons.first)
    if page.uri.to_s =~ /new/
      puts "Album could not be created!"
      exit 1
    else
      puts "* Album was successfully created"
    end
  else
    puts "There was a problem finding the album: #{exception}"
    exit 1
  end
end

# figure out how many files to process
files = if filename
  [ filename ]
else
  Dir.glob("#{directory}/*.*")
end
puts "* Processing #{files.size} files"

# process
files.each_with_index do |fname, idx|
  puts "-> (#{idx + 1} / #{files.size}) #{fname}"
  
  # get the upload page
  print "Fetching page... "
  STDOUT.flush
  page = agent.get("#{host_prefix}/photos/new")
  photo_form = page.forms.first
  photo_form['photo[album_id]'] = album
  print "Done. "
  STDOUT.flush
  
  # determine picture size
  width, height = nil, nil
  `identify "#{fname}"`.chomp.gsub(/ (\d+)x(\d+) /) do |match|
    width = $1.to_i
    height = $2.to_i
  end
  
  # convert if necessary
  converted = false
  basefname = nil
  if width.to_i > 1280 or height.to_i > 1280
    converted = true
    print "Converting... "
    STDOUT.flush
    basefname = "/tmp/#{File.basename(fname)}"
    `convert "#{fname}" -resize "1280x1280" "#{basefname}"`
    print "Done. "
    STDOUT.flush
  end
  
  # now upload it
  print "Uploading... "
  STDOUT.flush
  photo_form.file_uploads.first.file_name = (converted ? basefname : fname)
  page = agent.submit(photo_form, photo_form.buttons.first)
  if page.uri.to_s =~ /new/
    puts "Failed!"
  else
    puts "Success."
  end
  
  # remove resized image
  File.unlink(basefname) if converted
end

puts "Fin."


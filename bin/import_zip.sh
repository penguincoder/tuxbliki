#!/bin/bash

if [[ $# -ne 3 ]] ; then
  echo Usage: $0 [zipfile] [author_name] [album_name]
  exit 1
fi

merb -i <<EOF

require 'zip/zipfilesystem'
author = Author.find_by_name '$2'
if author.nil?
  \$stderr.puts "Author is missing!"
  return false
end
album = Album.find_by_name '$3'
if album.nil?
  \$stderr.puts "Album is missing!"
  return false
end
Zip::ZipFile.open('$1') do |zipfile|
  zipfile.dir.entries('.').each do |ifile_name|
    puts ifile_name
    ifile = Tempfile.new(ifile_name)
    ifile.write zipfile.file.read(ifile_name)
    ifile.rewind
    photo = Photo.new :album_id => album.id,
      :file => {
        :content_type => 'image/jpeg',
        :size => ifile.size,
        :tempfile => ifile,
        :filename => ifile_name
      }
    photo.author_id = author.id
    unless photo.save
      \$stderr.puts "PHOTO (#{ifile_name}) SAVE FAILED:"
      photo.errors.each_full { |msg| \$stderr.puts " * #{msg}" }
    end
  end
end

EOF

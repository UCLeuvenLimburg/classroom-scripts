require 'zip'
require 'fileutils'


def extract_student_name(filename, contents)
  first_line = contents.lines[0].strip
  /^Name: (.*) \(q\d+\)$/ =~ first_line or abort "Could not extract student name from #{filename}"
  name = $1

  parts = name.split(/ /)
  fname = parts[0]
  lname = parts[1..-1].join(' ')

  [ fname, lname ]
end

def create_slug(fname, lname)
  "#{lname.downcase.gsub(/ /, '-')}-#{fname.downcase}"
end



if ARGV.size != 1
  puts "Please specify zip to unpack"
  
  abort
end

Zip::File.open(ARGV[0]) do |zip|
  qtable = {}
  
  zip.each do |entry|
    if /_(q\d{7})_attempt_\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}\.txt$/ =~ entry.name
      qid = $1

      contents = entry.get_input_stream.read
      fname, lname = extract_student_name(entry.name, contents)
      slug = create_slug(fname, lname)

      qtable[qid] = slug
      puts "Associated #{qid} with #{slug}"
    end
  end

  zip.each do |entry|
    /_(q\d{7})_/ =~ entry.name or abort "Could not find q-id in #{entry.name}"
    qid = $1
    slug = qtable[qid]

    if not slug
      puts "Unrecognized q-id #{qid}"
      abort
    end

    puts "Creating directory #{slug} (if it does not exist yet)"
    FileUtils.mkdir_p slug

    puts "Extracting #{entry.name} to #{slug}/#{entry.name}"
    entry.extract("#{slug}/#{entry.name}")
  end
end

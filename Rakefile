require 'toml'

def extract_title(argv)
  title = argv.last
  abort 'Please specify TITLE.' unless title and argv.length >= 2
  argv.slice(1,argv.size).each{|v| task v.to_sym do; end}
  title
end

def edit_metadata
  title = extract_title ARGV
  filename = "content/post/#{title}.md"
  abort "No such file: #{filename}." unless File.exists?(filename)
  content = File.open(filename, 'r').read
  metadata = (/^\++\n(?<metadata>[\s\S]*)\n\++\n/).match(content)[:metadata]
  hash = TOML.parse(metadata)
  yield hash
  edited_metadata = TOML.dump(hash)
  edited_metadata = "+++\n#{edited_metadata}+++\n"
  content = content.gsub(/^\++\n([\s\S]*)\n\++\n/, edited_metadata)
  File.open(filename, 'w').write(content)
end

task :publish do
  edit_metadata do |hash|
    hash['date'] = Time.now.strftime('%FT%T%:z')
    hash['draft'] = false
  end
end

task :unpublish do
  edit_metadata do |hash|
    hash['draft'] = true
  end
end

task :post do
  title = extract_title ARGV
  sh "hugo new post/#{title}.md"
  Rake::Task['unpublish'].invoke(title)
end

task edit: :emacs

task :vim do
  title = extract_title ARGV
  filename = "content/post/#{title}.md"
  abort "No such file: #{filename}." unless File.exists?(filename)
  sh "vim #{filename}"
end

task :emacs do
  title = extract_title ARGV
  filename = "content/post/#{title}.md"
  abort "No such file: #{filename}." unless File.exists?(filename)
  sh "emacs #{filename}"
end

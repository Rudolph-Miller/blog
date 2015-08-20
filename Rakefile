require 'toml'

def edit_metadata
  title = ENV['TITLE']
  filename = "content/post/#{title}.md"
  if File.exists?(filename)
    content = File.open(filename, 'r').read
    metadata = (/^\++\n(?<metadata>[\s\S]*)\n\++\n/).match(content)[:metadata]
    hash = TOML::Parser.new(metadata).parsed
    yield hash
    edited_metadata = TOML::Generator.new(hash).body
    edited_metadata = "+++\n#{edited_metadata}+++\n"
    content = content.gsub(/^\++\n([\s\S]*)\n\++\n/, edited_metadata)
    File.open(filename, 'w').write(content)
  else
    abort "No such file: #{filename}."
  end
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

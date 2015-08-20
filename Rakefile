def edit_post
  title = ENV['TITLE']
  filename = "content/post/#{title}.md"
  if File.exists?(filename)
    content = File.open(filename, 'r').read
    content = yield content
    File.open(filename, 'w').write(content)
  else
    abort "No such file: #{filename}."
  end
end

task :publish do
  date = Time.now.strftime('date = "%FT%T%:z"')
  edit_post do |content|
    content
    .gsub(/^date = .*$/, date)
    .gsub(/^draft = .*$/, 'draft = false')
  end
end

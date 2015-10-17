require 'toml'

def extract_title(argv, options = {})
  title = argv.last
  unless title and argv.length >= 2
    if options[:ignore_error]
      return
    else
      abort 'Please specify TITLE.' 
    end
  end
  argv.slice(1,argv.size).each{|v| task v.to_sym do; end}
  title
end

def edit_metadata
  title = extract_title ARGV
  filename = "content/post/#{title}.md"
  abort "No such file: #{filename}." unless File.exists?(filename)
  content = File.open(filename, 'r').read
  metadata_regex = /^\+\+\+\n(?<metadata>[\s\S]*)\n\+\+\+\n/
  metadata = metadata_regex.match(content)[:metadata]
  hash = TOML.parse(metadata)
  yield hash
  hash['Description'] ||= 'WIP'
  hash['Tags'] ||= ['WIP']
  edited_metadata = TOML.dump(hash)
  edited_metadata = "+++\n#{edited_metadata}+++\n"
  content_regex = /^\+\+\+\n([\s\S]*)\n\+\+\+\n/
  content = content.gsub(content_regex , edited_metadata)
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

namespace :ls do
  task :slide do
    sh 'ls -t content/slide'
  end
end

task :ls do
  sh 'ls -t content/post'
end

task edit: :vim

def edit(argv, command, type='post')
  title = extract_title argv, ignore_error: true
  command = command.to_s
  type = type.to_s
  if title
    if title == 'last'
      title = `ls -t content/#{type} | head -1 | cut -f 1 -d '.' | tr -d '\n'`
    end
    filename = "content/#{type}/#{title}.md"
    abort "No such file: #{filename}." unless File.exists?(filename)
    sh "#{command} #{filename}"
  else
    sh "ls -t content/#{type} | peco | pbcopy && #{command} content/#{type}/`pbpaste`"
  end
end

task vi: :vim

task :vim do
  edit ARGV, :vim
end

namespace :vim do
  task :slide do
    edit ARGV, :vim, :slide
  end
end

task :emacs do
  edit ARGV, :emacs
end

namespace :emacs do
  task :slide do
    edit ARGV, :emacs, :slide
  end
end

task :server do
  sh 'hugo server -wD'
end

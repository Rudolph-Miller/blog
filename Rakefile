require 'toml'

SCREENSHOT_DIR = '~/Pictures/Screenshots'
GIF_DIR = '~/Pictures/gif'

def extract_title(argv, options = {})
  title = argv.last
  commands = argv.first.split(':')
  if commands.length > 1
    type = commands[1]
  else
    type = 'post'
  end
  unless title and argv.length >= 2
    if options[:ignore_error]
      return [nil, type]
    else
      abort 'Please specify TITLE.' 
    end
  end
  argv.slice(1,argv.size).each{|v| task v.to_sym do; end}
  [title, type]
end

def edit_metadata
  title, type = extract_title ARGV, ignore_error: true
  if title
    filename = "content/#{type}/#{title}.md"
  else
    filename = \
      `ls -t content/#{type} | peco | pbcopy && \
      echo content/#{type}/\`pbpaste\` | tr -d '\n'`
  end
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

namespace :publish do
  task :slide do
    edit_metadata do |hash|
      hash['date'] = Time.now.strftime('%FT%T%:z')
      hash['draft'] = false
    end
  end
end

task :unpublish do
  edit_metadata do |hash|
    hash['draft'] = true
  end
end

namespace :unpublish do
  task :slide do
    edit_metadata do |hash|
      hash['draft'] = true
    end
  end
end

task :post do
  title, _ = extract_title ARGV
  sh "hugo new post/#{title}.md"
  Rake::Task['unpublish'].invoke(title)
end

task :slide do
  title, _ = extract_title ARGV
  sh "hugo new slide/#{title}.md"
  `rake unpublish:slide #{title}`
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
  title, _ = extract_title argv, ignore_error: true
  command = command.to_s
  type = type.to_s
  if title
    if %w(last latest).include? title
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

namespace :vi do
  task :slide do
    edit ARGV, :vim, :slide
  end
end

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

def image_dir_name
  date = Time.now.strftime('%Y%m%d')
  "static/images/#{date}"
end

task :image_directory do
  dir = image_dir_name
  FileUtils.mkdir_p(dir)
  puts dir
end

task :cp_ss do
  name = ARGV.last
  ARGV.slice(1, ARGV.size).each{|v| task v.to_sym do; end}

  last_screenshot = `ls -t #{SCREENSHOT_DIR} | head -1`.gsub(' ', '\ ').gsub(/\n/, '')

  dir = image_dir_name
  FileUtils.mkdir_p(dir)

  sh "cp #{SCREENSHOT_DIR}/#{last_screenshot} #{dir}/#{name}"
end

task :cp_gif do
  name = ARGV.last
  ARGV.slice(1, ARGV.size).each{|v| task v.to_sym do; end}

  last_gif = `ls -t #{GIF_DIR} | head -1`.gsub(' ', '\ ').gsub(/\n/, '')

  dir = image_dir_name
  FileUtils.mkdir_p(dir)

  sh "cp #{GIF_DIR}/#{last_gif} #{dir}/#{name}"
end

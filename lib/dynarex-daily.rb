#!/usr/bin/env ruby

# file: dynarex-daily.rb

require 'dynarex'
require 'rxfileio'


class DynarexDaily < Dynarex
  include RXFileIOModule

  def initialize(stringx=nil, dir_archive: :days, xslt: '',
                 filename: 'dynarexdaily.xml', debug: false)

    @dir_archive = dir_archive

    @filename = filename
    @schema = 'entries[date]/entry(time, desc)'
    @default_key = 'uid'
    @debug = debug

    puts 'DynarexDaily::initialize stringx: ' + stringx.inspect  if @debug

    if stringx then
      s, type = RXFHelper.read(stringx)
      @filename = stringx if type == :file or type == :dfs
    end

    puts 'DynarexDaily::initialize @filename: ' + @filename.inspect  if @debug

    if FileX.exists?(@filename) then

      super @filename, debug: debug

      if !summary[:date].empty? and \
          Date.parse(summary[:date]) != Date.today then

        archive_file Date.parse(summary[:date])
        create_file
      end

    else
      puts 'before super: stringx: ' + stringx.inspect if @debug
      super( stringx || @schema , debug: debug)
      puts 'after super' if @debug
      @delimiter = ' # '
      create_file
    end

    self.xslt = xslt if xslt
  end

  def create(h)

    if !summary[:date].empty? and \
        Date.parse(summary[:date]) != Date.today then

      archive_file Date.parse(summary[:date])
      create_file
    end

    super(h)
  end


  def save(filename=@filename, options={})

    puts 'inside DynarexDaily::save() filename: ' + filename.inspect if @debug
    super(filename, options)

  end

  def schema=(s)
    super(s.sub(/^\w+(?=\/)/,'\0[date]'))
    summary[:date] = Date.today.to_s
    summary[:order] = 'descending'
  end

  private

  def create_file()

    puts 'inside DynarexDaily::create_file' if @debug

    openx(@schema)
    summary[:date] = Date.today.to_s
    summary[:order] = 'descending'

    save
  end

  def archive_file(t)

    puts 'inside DynarexDaily::archive_file' if @debug

    dir, file = if @dir_archive == :days then
      ['days', t.strftime("d%d%m%y.xml")]
    else
      [t.strftime("%Y/%b/%d").downcase, 'index.xml']
    end

    FileX.mkdir_p dir unless FileX.exist? dir

    if @debug then
      puts 'inside DynarexDaily::archive_file '
      puts '  @filename: %s' % [@filename]
      puts '  dir: %s; file: %s' % [dir, file]
      puts '  FileX: %s' % [dir, FileX.pwd]
    end

    FileX.mv(@filename, "%s/%s" % [dir, file])
    puts 'inside DynarexDaily::archive_file after FileX.mv' if @debug

  end

end

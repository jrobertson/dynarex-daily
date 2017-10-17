#!/usr/bin/env ruby

# file: dynarex-daily.rb

require 'dynarex'
require 'fileutils'

class DynarexDaily < Dynarex

 
  def initialize(stringx=nil, dir_archive: :days, xslt: '', 
                 filename: 'dynarexdaily.xml')
    
    @dir_archive = dir_archive

    @filename = filename
    @schema = 'entries[date]/entry(time, desc)'
    @default_key = 'uid'

    if stringx then
      s, type = RXFHelper.read(stringx)       
      @filename = stringx if type == :file
    end
    
    if File.exist?(@filename) then
      
      super @filename
      
      if !summary[:date].empty? and \
          Date.parse(summary[:date]) != Date.today then
        
        archive_file Date.parse(summary[:date])
        create_file
      end  
      
    else
      
      super( stringx || @schema )
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

    super(filename, options)

  end
  
  def schema=(s)
    super(s.sub(/^\w+(?=\/)/,'\0[date]'))
    summary[:date] = Date.today.to_s
    summary[:order] = 'descending'    
  end

  private
  
  def create_file()
       
    openx(@schema)
    summary[:date] = Date.today.to_s
    summary[:order] = 'descending'

    save
  end

  def archive_file(t)

    dir, file = if @dir_archive == :days then
      ['days', t.strftime("d%d%m%y.xml")]
    else
      [t.strftime("%Y/%b/%d").downcase, 'index.xml']
    end

    FileUtils.mkdir_p dir unless File.exist? dir
    FileUtils.mv(@filename, "%s/%s" % [dir, file])

  end

end

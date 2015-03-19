#!/usr/bin/env ruby

# file: dynarex-daily.rb

require 'dynarex'
require 'fileutils'

class DynarexDaily < Dynarex

  attr_writer :xml_instruction
  
  def initialize(stringx=nil, options={})

    @opt = {dir_archive: :days}.merge options
    @filename = 'dynarexdaily.xml'
    @schema = 'entries[date]/entry(time, desc)'
    @default_key = 'uid'
    
    if File.exist?(@filename) then
      
      super(@filename)
      
      if !summary[:date].empty? and \
          Date.parse(summary[:date]) != Date.today then
        
        archive_file Date.parse(summary[:date])
        create_file
      end  
      
    else
      create_file
    end
  end
  
  def save(filename='dynarexdaily.xml', options={})

    blk = nil

    if @xml_instruction then

      blk = lambda do |xml| 
        a = xml.lines.to_a
        line1 = a.shift
        a.unshift @xml_instruction + "\n"
        a.unshift line1
        a.join
      end  
    end

    super(filename, options, &blk)

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

    dir, file = if @opt[:dir_archive] == :days then
      ['days', t.strftime("d%d%m%y.xml")]
    else
      [t.strftime("%Y/%b/%d").downcase, 'index.xml']
    end

    FileUtils.mkdir_p dir unless File.exist? dir
    FileUtils.mv(@filename, "%s/%s" % [dir, file])

  end

end
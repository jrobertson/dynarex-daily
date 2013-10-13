#!/usr/bin/env ruby

# file: dynarex-daily.rb

require 'dynarex'
require 'fileutils'

class DynarexDaily < Dynarex

  attr_writer :xml_instruction
  
  def initialize(stringx=nil, options={})

    @opt = {dir_archive: :days}.merge options
    @filename = 'dynarexdaily.xml'
    super(stringx) if stringx

    if File.exist?(@filename) then 
      super(@filename)
      if !summary[:date].empty? and \
          Time.parse(summary[:date]).day != Time.now.day then
        archive_file Time.parse(summary[:date])
        create_file
      end  
    else
      create_file
    end
  end
  
  def save()

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

    super(@filename, &blk)

  end

  private
  
  def create_file()
    
    FileUtils.touch @filename
    
    initialize('entries[date]/entry(time, desc)')
    summary[:date] = Time.now.to_s
    summary[:order] = 'descending'
    save
  end

  def archive_file(t)

    if @opt[:dir_archive] == :days then
      dir, file = 'days', t.strftime("d%d%m%y.xml")
    else
      dir, file = t.strftime("%Y/%b/%d").downcase, 'index.xml'
    end

    FileUtils.mkdir_p dir unless File.exist? dir
    FileUtils.mv(@filename, "%s/%s" % [dir, file])

  end

end
#!/usr/bin/env ruby

# file: dynarex-daily.rb

require 'dynarex'
require 'fileutils'

class DynarexDaily < Dynarex

  def initialize(stringx=nil)

    @filename = 'dynarexdaily.xml'
    super(stringx) if stringx

    if File.exist?(@filename) then 
      super(@filename)
      if !summary[:date].empty? and \
          Time.parse(summary[:date]).day != Time.now.day then
        archive_file
        create_file
      end  
    else
      create_file
    end
  end
  
  def save()
    super(@filename)
  end

  private
  
  def create_file()
    
    FileUtils.touch @filename
    
    initialize('entries[date]/entry(time, desc)')
    summary[:date] = Time.now.to_s
    summary[:order] = 'descending'
    self.save
  end

  def archive_file()
    dir = 'days'
    FileUtils.mkdir dir unless File.exist? dir
    FileUtils.mv(@filename, "%s/%s" % [dir, Time.now.strftime("d%d%m%y.xml")])
  end

end

# Introducing the DynarexDaily gem

The DynarexDaily gem is designed to create a Dynarex file on a daily basis. The archived files are stored in a directory called 'days'.

Here's a quick example:

    require 'dynarex-daily'

    DynarexDaily.new.create(time: Time.now.to_s, desc: 'desc 123').save


If the file dynarexdaily.xml doesn't exist then it is created and used to store the RecordX entries.

Here's the sample output from the example above:

    <?xml version='1.0' encoding='UTF-8'?>
    <entries>
      <summary>
        <date>2013-08-11 16:30:00 +0100</date>
        <recordx_type>dynarex</recordx_type>
        <format_mask>[!time] [!desc]</format_mask>
        <schema>entries[date]/entry(time, desc)</schema>
        <default_key>time</default_key>
        <order>descending</order>
      </summary>
      <records>
        <entry id='1' created='2013-08-11 16:30:00 +0100' last_modified=''>
          <time>2013-08-11 16:30:00 +0100</time>
          <desc>desc 123</desc>
        </entry>
      </records>
    </entries>

dynarexdaily gem

require 'json'
require 'date'

class Analytic
  ############ Stringfy json to convert it to a ruby hash ################
  value = '{
  "events": [
       {
           "url": "/pages/a-big-river",
           "visitorId": "d1177368-2310-11e8-9e2a-9b860a0d9039",
           "timestamp": 1512754583000
       },
       {
           "url": "/pages/a-small-dog",
           "visitorId": "d1177368-2310-11e8-9e2a-9b860a0d9039",
           "timestamp": 1512754631000
       },
      {
          "url": "/pages/a-big-talk",
          "visitorId": "f877b96c-9969-4abc-bbe2-54b17d030f8b",
          "timestamp": 1512709065294
      },
      {
          "url": "/pages/a-sad-story",
          "visitorId": "f877b96c-9969-4abc-bbe2-54b17d030f8b",
          "timestamp": 1512711000000
      },
      {
          "url": "/pages/a-big-river",
          "visitorId": "d1177368-2310-11e8-9e2a-9b860a0d9039",
          "timestamp": 1512754436000
      },
      {
          "url": "/pages/a-sad-story",
          "visitorId": "f877b96c-9969-4abc-bbe2-54b17d030f8b",
          "timestamp": 1512709024000
      }
  ]
}'

  events = JSON.parse(value)

  ########################## resulted ruby hash ##########################
  # {"events"=>[{"url"=>"/pages/a-big-river", "visitorId"=>"d1177368-2310-11e8-9e2a-9b860a0d9039", "timestamp"=>1512754583000},
  # {"url"=>"/pages/a-small-dog", "visitorId"=>"d1177368-2310-11e8-9e2a-9b860a0d9039", "timestamp"=>1512754631000},
  # {"url"=>"/pages/a-big-talk", "visitorId"=>"f877b96c-9969-4abc-bbe2-54b17d030f8b", "timestamp"=>1512709065294},
  # {"url"=>"/pages/a-sad-story", "visitorId"=>"f877b96c-9969-4abc-bbe2-54b17d030f8b", "timestamp"=>1512711000000},
  # {"url"=>"/pages/a-big-river", "visitorId"=>"d1177368-2310-11e8-9e2a-9b860a0d9039", "timestamp"=>1512754436000},
  # {"url"=>"/pages/a-sad-story", "visitorId"=>"f877b96c-9969-4abc-bbe2-54b17d030f8b", "timestamp"=>1512709024000}]}

  page_dur = []
  start_time = []
  result = {}
  events.values[0].each do |e|
    i = 0
    result = {
      "sessionsByUser" => {
        e.values[1].to_s => [
          {
            "duration" => Time.at(e.values[2] / 1000),
            "pages" => [
              e.values[i]
            ],
            "startTime" => e.values[2]
          }
        ]
      }
    }
    start_time << e.values[2]
    i += 1
    p result
  end

  ######## The expected output ######################
  # {"sessionsByUser"=>{"d1177368-2310-11e8-9e2a-9b860a0d9039"=>[{"duration"=>2017-12-08 19:36:23 +0200, "pages"=>["/pages/a-big-river"], "startTime"=>1512754583000}]}}
  # {"sessionsByUser"=>{"d1177368-2310-11e8-9e2a-9b860a0d9039"=>[{"duration"=>2017-12-08 19:37:11 +0200, "pages"=>["/pages/a-small-dog"], "startTime"=>1512754631000}]}}
  # {"sessionsByUser"=>{"f877b96c-9969-4abc-bbe2-54b17d030f8b"=>[{"duration"=>2017-12-08 06:57:45 +0200, "pages"=>["/pages/a-big-talk"], "startTime"=>1512709065294}]}}
  # {"sessionsByUser"=>{"f877b96c-9969-4abc-bbe2-54b17d030f8b"=>[{"duration"=>2017-12-08 07:30:00 +0200, "pages"=>["/pages/a-sad-story"], "startTime"=>1512711000000}]}}
  # {"sessionsByUser"=>{"d1177368-2310-11e8-9e2a-9b860a0d9039"=>[{"duration"=>2017-12-08 19:33:56 +0200, "pages"=>["/pages/a-big-river"], "startTime"=>1512754436000}]}}
  # {"sessionsByUser"=>{"f877b96c-9969-4abc-bbe2-54b17d030f8b"=>[{"duration"=>2017-12-08 06:57:04 +0200, "pages"=>["/pages/a-sad-story"], "startTime"=>1512709024000}]}}

  ########## Created This loop for calcuatin the time user spent on a page sinec i'm not sure what the timestamp reperesent
  i = 0
  while i <= start_time.length
    page_dur << start_time[i + 1] - start_time[i] unless start_time[i + 1] == nil
    i += 1
  end

  # ############ This array returns the time spent on each page however it's showing negative numbers since this is a test data
  p page_dur

  # ############ calculate the time user spent on the session in human readable format ############
  session_dur = Time.at(page_dur.inject(:+)).utc.strftime("%H:%M:%S")
end

# SimpleYoutube

## Usage


```ruby
require_relative 'simple_youtube'

SimpleYoutube.search query, options
```

This returns an array of URLs matching the query provided.

### Options

* `key`: Your YouTube developer key (defaults to YOUTUBE_DEV_KEY on ENV)
* `max`: Max results (defaults to 3)
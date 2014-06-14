# Sinatra API Template #

This is a reasonable API template for Sinatra.

No wait, actually this is a highly overthought README to help you read more to think less about the ways that you don't need to think about the repo it's in. Or something like that.

Versioned to ruby 2.1.1. For use in projects that need minimal conventions for single-purpose webservers built/maintained by mostly-rails teams. Carefully optimized such that further contributions/contributors experience minimal Sinatra-specific knowledge -- e.g. that might otherwise surprise Rails developers.

Sinatra can be made to excel as a general-purpose web doodad (e.g. that it, like Rails, can be customized for route-specific content types, serving public assets, including javascript etc). The point of this repo is to ignore those those features and facilitate **serving JSON to clients making structured requests**. I suppose it's the opposite of what Padrino does.

Yes, ActiveRecord, used identically as with Rails, and with migrations where you'd think they'd be. Worry not -- also with that familiar setup and those critical _rake tasks_ that should keep you running in no time.

# Basic Features #
Starting with the less opinionated choices made for all API-based projects:
- Sinatra
  - Set only to respond with json -- if your scope goes beyond this, this is configured in a `before` block but the conventions of this app will probably no longer be helpful then.)
- Activerecord
  - Setup with sqlite. Also rails-style: -- `/db` and `config/database.yml`. Sinatra-activerecord is awesome also brings the Rails-availed Rake tasks with it. _Important Note:_ versioned 4.1.1.
- pry (w pry-stack_explorer and pry-rescue) for debugging
- rspec
- puma as the webserver

# Table of Contents #
- [Api.rb -- Main Sinatra Class]
- [/helpers]
  - [*Utils modules in /helpers/*.rb]
  - [Error classes in /helpers/errors/*]
  - [/helpers/concerns/* ###
  - [Module mixins in /helpers/concerns/*]



## Api.rb -- Main Sinatra Class ##
Informatively named `Api`, where which is the app module e.g. where all route definitions are. Also is a top-level namespace.

## /helpers ##

### *Utils modules in /helpers/*.rb ###
Designated for *Sinatra-specific helper modules* in *_utils.rb. Usually they're just a namespace for related functionality, distinguished only by being usable in request scope (typically in a url-matching block). Include in the `api.rb` body such like
```ruby
helpers ErrorUtils, SinatraUtils
```


Counterintuitively, I've named the very bare first couple with (*)`Utils` just to avoid _with a ten foot pole_ any annoying load path / namespacing issues. You know, where things with a common name suffix (*Helper) live inside or sibling to a similarly named directory (/helper).

IMO this is one place where ActiveSupport's effects on modules imho bring are unwelcome and, what's worse, can actually muddle loading/requiring traces to the point of unreadability.

Two subfolders in here:

### Error classes in /helpers/errors/* ###
This is important. The quality of a webservice rests critically on the quality of its errors reported to the client. It must
- throw the right status code AS WELL AS
- send a response body of the specified type (json) that HAVE ALSO
- identifies deficiencies in the request (e.g. missed parameters -- or however to make a bad request a GOOD one).

Put errors individually in their own classes in this fodler. I've specifically set this up to discourage the following:
```ruby
MyErrorOne < StandardError; self; end
MyErrorTwo < StandardError; self; end
```

To that end, there are also some conventions to help with that

### Module mixins in /helpers/concerns/* ###
*Where to put mixin modules.* Isolated in a folder distinctly to be required differently vs. _sinatra helpers_ which are also modules.

In Sinatra, *Helpers are just collections of functions* (again, placed in `/helpers/*_utils.rb`) that, when included, are available to instances of requests (e.g. they have *request scope*). For 'ACTUAL' modules to be augment functionality elsewhere, follow the convention of separating them here.

To that end, there's a *potentially helpful `DescribableError` mixin* for serializing the output of error classes.


```ruby
#  1) force the error in the API
put('/favorite') do
  raise BlueVelvetError if params[:beer] is not "Pabst Blue Ribbon"
  #...
end

#  2) specify what to do when you catch it e.g. :send_json_error
#  which will send to :json_error on that error's class's instance method

error BlueVelvetError
  send_json_error 403, env
# or to send a non-informative json message, use
# `halt_json_error <yr_error>, env.slice(<what to serialize>)`
end


#  3) include DescribableError on an error (ex)
#  define a #transform_error method
#  which takes the request's context as an argument,
#  and which is called by <that_error_class>#json_error
class BlueVelvetError < StandardError
  include DescribableError
  transform_error do |given_request_env|
    {
      :message => given_request_env['message'],
      # :error_name in case you refer api clients to documentation
      :error_name => given_request_env['sinatra.error'].class.name,
      :url_method => given_request_env['REQUEST_METHOD'],
      :url_requested => given_request_env['rack.request.query_string'],
      :explanation => explain_error(given_request_env['rack.request.query_hash']),
      :documentation => 'http://www.bfi.org.uk/news-opinion/sight-sound-magazine/comment/through-bottle-darkly-blue-velvets-freudian-beers'
    }
  end

  def self.explain_error(error_hzh)
# return some string explaining what's wrong with Heineken
  end

end
```

## DB and Config ##
Informatively named `Api`


## Versioning ##
- `RUBY_VERSION 2.1.1` (set by Gemfile and rbenv local)
- `activerecord` 4.1.1
- ^ because of that, `protected_attributes` (not required for '~< 4' versions of activerecord)
- `activesupport` (and its ilk) 4.1.1
-
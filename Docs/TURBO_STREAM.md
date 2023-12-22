# Rails Turbo Stream and Fames
- Actions without reloading the page

## Setup:
- Add the turbo-rails gem to your Gemfile: `gem 'turbo-rails'`
- Run `./bin/bundle install`
- Run `./bin/rails turbo:install` installs and configures turbo
- Run `./bin/rails turbo:install:redis` to change the development Action Cable adapter from Async (the default one) to Redis

## Basics Use Case of Streams

In this step, we're going to do a simple hack, where you broadcast from the console and changes is seen live on site.


**1. Our partial**

```erb
<div class="py-4 mb-8 border text-center shadow-lg font-bold bg-white">
  <%= Time.now.strftime("%d %b %Y, %H:%M:%S") %>
</div>
<p class="my-4">Lorem ipsum dolor</p>
```

This partial just displayes the current time and the lorem ipsum text. Basically, to dispatch a event / stream event we need a same partial name.

**2. Our main template**

```erb
<%= turbo_stream_from "mystr" %>

<div class="my-8 w-full mx-auto" id="content">
  <%= render "streamed_stuff" %>
</div>

```

This is the template where we want the dynamicity.

- In the very first line `<%= turbo_stream_from "mystr" %>` we're interested to listen for a broadcast to `mystr`

- Now, we need to tell, where it'll append, and how the html will be constructed. So, we pass a template.


**3. Let's trigger event**

```rb
Turbo::StreamsChannel.broadcast_update_to("mystr", target: "content", partial: "site/streamed_stuff")
```

This command will, trigger a broadcast to the **mystr** which **updates** the **content id** of the interested page grabing a content from the **partial** located at `views/site/streamed_stuff`

```rb
Turbo::StreamsChannel.broadcast_append_to("mystr", target: "content", partial: "site/streamed_stuff")
```

This command will, trigger a broadcast to the **mystr** which **appends** the html **partial** located at `views/site/streamed_stuff` to the `content` id of the interested page

**4. Passing a locals to partial from event:**

We need to access the value passed from partial in our template:

> Partial

```erb
<div class="py-4 mb-8 border text-center shadow-lg font-bold bg-white">
  <%= Time.now.strftime("%d %b %Y, %H:%M:%S") %>
</div>

  <p class="my-4">Lorem ipsum dolor</p>
<p><%= defined?(my_value) && my_value.present?  ? my_value : 10  %></p>
```

> Broadcasting event with locals

```rb
Turbo::StreamsChannel.broadcast_update_to("mystr", target: "content", partial: "site/streamed_stuff", locals: {my_value: 22})
```

## 2. Usage with template button event

We'll now reload the part of the page in this part.

> Our Partial

```erb
<p>Hi</p>

<p><%= defined?(my_value) && my_value.present?  ? my_value : 10  %></p>
```

This part displays the value of local my_value passed.


> Our Template

```erb
<%= turbo_stream_from "event_when_button_clicked" %>

<%= button_to "Click me", third_page_path, remote: true, class: "turbo-frame" %>

<div class="my-8 w-full mx-auto" id="content">
  <%= render "dynamic_content" %>
</div>

```

We're interested to listen to an event `event_when_button_clicked` which is triggerd when clicking the `Click Me` button.

```
<%= turbo_stream_from "event_when_button_clicked" %>
```

which basically is handled by the third_page_path i.e. third_page route which corresponds to `third` controller method.


> Controller

```rb
class SiteController < ApplicationController 

    def first
    end

    def second
    end 

    def third
        respond_to do |format|
            format.html { render :third_page }
            format.turbo_stream { head  Turbo::StreamsChannel.broadcast_update_to(
                "event_when_button_clicked",
                target: "content",
                partial: "site/dynamic_content",
                locals: {
                  my_value: 1000
                }
            )}
          end        
    end
end
```

So, in the third page what we do is, we turbo stream the head value with broadcast object.

**Also need to make sure that in our routes, the path is post.**

```rb
Rails.application.routes.draw do
  ...
  ...
  post "/third", to: "site#third", as: :third_page
  ...
end
```
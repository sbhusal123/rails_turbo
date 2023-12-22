# Turbo Frame:
- Performs client side refresh from the server side.
- Different from streams.


## Basic usage with passing params to controller

**Partials**

> _ajax_template.html.erb

```erb
Hi, it's <%= Time.now %>.

<%= params["values_to_pass_to_controller"] ? params["values_to_pass_to_controller"] : ""  %>
```

- In the above partial, we're checking, what's the current time
- In the second line, we're checking if there is any params passed to controller, if so we're displaying that.

**Our template where we want effect**

```erb
<!DOCTYPE html>
<html>
<head>
  <title>Turbo Frame Example</title>
  <style>
    body {
      margin: 10%
    }
  </style>
</head>
<body>

<%= button_to 'Click me', fifth_page_path(values_to_pass_to_controller: "Value passed from event"), remote: true %>

<%= turbo_frame_tag 'hello_frame' do %>
  <%= render partial: 'ajax_template' %>
<%end %>
</body>

</html>
```

Here, we've initialized a turbo frame named: `hello_frame` and on clicking the button `Click me` we call it and pass the parameter in the controller path function. 

```erb
<%= button_to 'Click me', fifth_page_path(values_to_pass_to_controller: "Value passed from event"), remote: true %>
```

- We've a partial that is responsible for rendering the html from the data provided by the stream named `ajax_template`

- Clicking of the button is handled by `fifth_page_path` which in turn is handled by `fifth` method in our controller.


> Controller

```ruby
class SiteController < ApplicationController 
    def fifth
      render turbo_stream: turbo_stream.update('hello_frame', partial: 'ajax_template', locals: { hello_content: @hello_content })
    end
end
```

Here in the controller, we're updating the template using a turbo stream.

Also make sure that the, fifth route is post only. i.e.

```rb
Rails.application.routes.draw do
  post "/fifth", to: "site#fifth", as: :fifth_page
end
```

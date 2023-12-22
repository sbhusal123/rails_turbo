Rails.application.routes.draw do
  get "/first", to: "site#first", as: :first_page
  get "/second", to: "site#second", as: :second_page
  post "/third", to: "site#third", as: :third_page
end

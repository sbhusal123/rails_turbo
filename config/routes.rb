Rails.application.routes.draw do
  get "/first", to: "site#first", as: :first_page
end

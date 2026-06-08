# Orientation, for anyone new to RSpec on Rails:
#
# - `bundle exec rspec` scans `spec/` for files ending in `_spec.rb` and runs them.
#   This file lives in `spec/requests/` by convention — request specs simulate real
#   HTTP requests hitting the app (router -> controller -> view), as opposed to
#   model specs (just the model) or system specs (a real browser via Capybara).
# - `require "rails_helper"` loads `spec/rails_helper.rb`, which boots the Rails
#   environment, loads support files, and configures RSpec/FactoryBot/etc. Plain
#   `spec_helper` (no Rails) is for specs that don't need the app loaded at all.
# - `describe` groups related examples under a label (often the thing under test).
#   `it` declares a single example ("a test"); its string describes the expected
#   behavior. `expect(actual).to matcher` is how you assert — here `eq(200)` checks
#   for an exact match and `have_http_status(:ok)` is the Rails-flavored equivalent.
require "rails_helper"

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns 200 and renders the hello text" do
      get root_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Hello, world!")
    end
  end
end

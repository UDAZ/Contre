RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
    #driven_by :selenium_chrome_headless, screen_size: [1400, 1400]
  end
end

require 'rails_helper'

RSpec.configure do |config|
  #database cleaner gem setup
  config.use_transactional_fixtures = false

  config.before(:suite) do
  DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
  DatabaseCleaner.start
  end

  config.after(:each) do
  DatabaseCleaner.clean
  end
end

RSpec.feature "Adam can create new post" do
  let!(:category) { FactoryGirl.create(:category, category_name: "Photo Walk") }

  before do
    visit new_post_path
    expect(page).to have_content "Photo Walk"
  end

  scenario "with valid attributes", js: true do
    fill_in "post_title", with: "Crossing the Rainbow Bridge to Odaiba"
    click_button "new-block"

    fill_in "postyear", with: "2016"
    select "April", from: "postmonth"
    select "10", from: "postday"
    choose "Photo Walk"

    click_button "Create Post!"
    sleep 1
    expect(page).to have_content "Post has been created successfully."
    expect(page).to have_content "Crossing the Rainbow Bridge to Odaiba"
    expect(page).to have_content "Photo Walk"
    expect(page).to have_content "2016-04-10"
  end

  scenario "not with invalid attributes", js: true do
    click_button "Create Post!"
    expect(page).to have_content "Category must exist"
    expect(page).to have_content "Title can't be blank"
  end
end
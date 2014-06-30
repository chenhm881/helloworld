require 'spec_helper'

feature "Widget management" do
  scenario "User creates a new widget" do
    visit "/articles"

    fill_in "title", :with => "da"
    click_button "Search"

    expect(page).to have_text("Listing articles")
  end
end

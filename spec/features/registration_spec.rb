require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name and unique email' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with: 'test'
    fill_in :user_password_confirmation, with: 'test'
    click_button 'Create New User'

    expect(current_path).to eq("/dashboard")
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    User.create(name: 'User One', email: 'notunique@example.com', password: 'tester', password_confirmation: 'tester')

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in :user_password, with: 'test'
    fill_in :user_password_confirmation, with: 'test'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end
end

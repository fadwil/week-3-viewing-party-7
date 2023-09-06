require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: 'tester', password_confirmation: 'tester')
    user2 = User.create(name: "User Two", email: "user2@test.com", password: 'tester', password_confirmation: 'tester')
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: 'tester', password_confirmation: 'tester')
    user2 = User.create(name: "User Two", email: "user2@test.com", password: 'tester', password_confirmation: 'tester')

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
    end     
  end 

  describe "Logging In" do
    it 'can log in with valid credentials' do
      user = User.create!(name: 'User One', email: 'notunique@example.com', password: 'tester', password_confirmation: 'tester')

      visit '/'

      expect(page).to have_link("Log In")
      click_link "Log In"
      expect(current_path).to eq(login_path)

      fill_in :email, with: user.email
      fill_in :password, with: user.password

      click_on "Log In"

      expect(current_path).to eq(user_path(user.id))
    end

    it 'cannot log in with invalid credentials' do
      user = User.create!(name: 'User One', email: 'notunique@example.com', password: 'tester', password_confirmation: 'tester')

      visit '/'
      
      click_on "notunique@example.com"
      
      expect(current_path).to eq(login_path)
      
      fill_in :email, with: user.email
      fill_in :password, with: 'wrongpassword'
    
      click_on "Log In"
      
      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, your credentials are bad.")

      fill_in :email, with: 'wrongemail@example.com'
      fill_in :password, with: 'tester'
  
      click_on "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, your credentials are bad.")
      
      fill_in :email, with: user.email
      # no password
      
      click_on "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, your credentials are bad.")

      # no email
      fill_in :password, with: 'tester'

      click_on "Log In"

      expect(current_path).to eq(login_path)
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  end
end

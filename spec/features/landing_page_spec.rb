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

    visit root_path

    click_link "Log In"

    fill_in :email, with: user1.email
    fill_in :password, with: user1.password

    click_on "Log In"

    click_on "Home"

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

      expect(current_path).to eq("/dashboard")
    end

    it 'cannot log in with invalid credentials' do
      user = User.create!(name: 'User One', email: 'notunique@example.com', password: 'tester', password_confirmation: 'tester')

      visit '/'
      
      click_on "Log In"
      
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

  describe "logging out" do
    it "logged-in user logs out" do
      user = User.create!(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
      visit login_path
      fill_in 'Email', with: 'test@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log In'
      
      expect(page).to have_content("Welcome, Test User!")
      
      visit '/'
      
      expect(page).to have_link('Log Out')
      expect(page).to_not have_link('Log In')

      click_link 'Log Out'
      
      expect(current_path).to eq(root_path)
      
      expect(page).to have_link('Log In')
      expect(page).to_not have_link('Log Out')
    end
  end

  describe "dashboard" do
    it "returns message to be logged in or registered to access dashboard" do
      visit '/dashboard'

      expect(current_path).to eq(root_path)

      expect(page).to have_content("You must be logged in or registered to access your dashboard.")
    end
  end
end

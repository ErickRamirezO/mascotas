Feature: Login Fail
    Scenario: Login with valid credentials
        Given I am on the login page
        When I enter an invalid credentials
        And I press the login button
        Then I should see the home page

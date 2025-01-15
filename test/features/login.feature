Feature: Login Success
  Scenario: Login with valid credentials
    Given I am on the login page
    When I enter a valid credentials
    And I press the login button
    Then I should see the home page

Feature: Login
  Scenario: User tries to login with invalid credentials
    Given I am on the login page
    When I enter an invalid username and password
    And I press the login button
    Then I should see an error dialog

Feature: Register Page Fail

  Scenario: User registration failed
    Given I am on the register page
    When I fill the registration form
    And I submit the registration form
    Then I should see the success message
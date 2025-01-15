Feature: Register Mascota Fail

  Scenario: Create a new post with incorrect data
    Given I am on the register mascota page
    When I fill the registration form with incorrect data
    And I submit the registration form
    Then I should see an error message
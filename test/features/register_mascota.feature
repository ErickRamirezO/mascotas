Feature: Register Mascota Success

  Scenario: Create a new post with correct data
    Given I am on the register mascota page
    When I fill the registration form with correct data
    And I submit the registration form
    Then I should see the success message
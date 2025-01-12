Feature: MascotasPage

  Scenario: Verify AppBar and pet list
    Given I am on the mascotas page
    Then I should see the app bar and at least one pet item

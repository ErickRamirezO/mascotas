Feature: Home Screen Success

  Scenario: Refresh images when FloatingActionButton is pressed
    Given I am on the home screen
    When I wait for seven seconds
    Then The images should refresh
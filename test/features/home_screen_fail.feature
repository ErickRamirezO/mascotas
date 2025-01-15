Feature: Home Screen Fail

  Scenario: Fail to refresh images when waiting for 7 seconds
    Given I am on the home screen
    When I wait for seven seconds
    Then The images should not refresh
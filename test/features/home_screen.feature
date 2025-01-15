Feature: HomeScreen

  Scenario: Refresh images when FloatingActionButton is pressed
    Given I am on the home screen
    When I press the refresh button 3 times
    Then The images should refresh
Feature: Mostrar ActionSheet con opciones de imagen

  Scenario: Mostrar ActionSheet y seleccionar una opción
    Given I am on the page with the action sheet button
    When I tap the show action sheet button
    And I should see an alert dialog with options Abrir cámara and Abrir galería
    And I tap the Abrir cámara option
    Then The alert dialog should disappear
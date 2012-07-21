Feature: View a tweet

  In order to be entertained
  As a site visitor
  I want to see the details of a single tweet

  Scenario: anonymous access
    Given I am not logged in
    When I ask for a single tweet's details
    Then I should see the text
    And I should see the author details
    And I should see the timestamp details

Feature: Run a crawl

  In order to include the latest tweets
  As an administrator
  I want to initiate a crawl

  Scenario: typical crawl
    Given there are no tweets
    And a user to be crawled
    When I request a crawl
    Then there should be new tweets

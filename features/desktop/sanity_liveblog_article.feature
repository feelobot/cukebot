@selenium @sanity @monitor

Feature: Live Blog

  Scenario: Has no 500s
    Given I navigate to "articles/2058052-nfl-draft-2014-results-live-reaction-analysis-for-rounds-2-3"
    Then their should be no 500 error

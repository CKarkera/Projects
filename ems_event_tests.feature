
Feature: EMSLinkApp Event Validation

  Background:
    * url 'https://entlinksapp-qa.webaroo.com/EMSLinkApp/API/stat'
    * header Content-Type = 'application/json'
    * header Cookie = 'rememberMe=false'

  @run
  Scenario Outline: Validate EMS event API
    * def reqBody = read('classpath:payloads/<fileName>')
    Given request reqBody
    When method POST
    Then status 200
    And match response == ''

    # Assert event field
    * match reqBody.event == "<expected_event>"

    # Assert email is present
    * match reqBody.email == "<expected_email>"

    # Assert timestamp is number
    * match reqBody.timestamp == '#number'

    # Assert recipientId is present
    * match reqBody.recipientId != null

    Examples:
      | fileName     | expected_event | expected_email                  |
      | emslink1.json  | click          | chaithanya.karkera@dummyhit.com  |
      | emslink2.json  | open           | chaithanya.karkera@dummyhit.com  |
      | emslink3.json  | processed      | sparsh.gupta@dummyhit.com        |
      | emslink4.json  | delivered      | sparsh.gupta@dummyhit.com        |
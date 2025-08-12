@deletetoken
Feature: Delete individual token

  Scenario: Delete provided token
    * def baseUrl = 'https://enterprise-qa.webaroo.com/GatewayAPI'
    * def userId = 2000700946
    * def password = '5zcynM'

    Given url baseUrl + '/api/auth/delete'
    And request { webRequest: false, userId: #(userId), password: '#(password)', token: '#(token)' }
    When method POST
    Then status 200



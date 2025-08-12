Feature: Token Flow for EMS_POST_CAMPAIGN

  Background:
    * def baseUrl = 'https://enterprise-qa.webaroo.com/GatewayAPI'
    * def userId = 2000700946
    * def password = '5zcynM'
    * def bearerToken = ''
    * configure headers = { Content-Type: 'application/json' }

  @tokenFlow
  Scenario: Ensure not more than 5 tokens exist, delete all if 5, then create a token and call EMS_POST_CAMPAIGN

    Given url baseUrl + '/api/auth/get'
    And request { webRequest: false, userId: #(userId), password: '#(password)' }
    When method POST
    Then status 200

    * def tokenList = response.tokens
    * def tokenCount = tokenList.length
    * print 'Existing tokens:', tokenList
    * print 'Token count:', tokenCount

#    # If token count >= 5, delete all tokens
#    * if (tokenCount >= 5)
#    * karate.forEach(tokenList, function(token){ karate.call('classpath:api/delete_token.feature', { token: token }) })
#    * if (tokenCount >= 5) karate.forEach(tokenList, function(token){ karate.call('classpath:api/delete_token.feature', { token: token }) })
    * if (tokenCount >= 5) karate.forEach(tokenList, x => karate.call('classpath:api/delete_token.feature', { token: x.details.token }))


    # Create a new token
    Given url baseUrl + '/api/auth/create'
    And request { webRequest: false, userId: #(userId), password: '#(password)'}
    When method POST
    Then status 200
    * def newToken = response.tokens[0].details.token
    * def bearerToken = 'Bearer ' + newToken
    * print 'Created new token:', bearerToken


    # Use the new token to send EMS_POST_CAMPAIGN
    Given url baseUrl + '/rest'
    And configure headers = { Authorization: '#(bearerToken)' }
    And form field method = 'EMS_POST_CAMPAIGN'
    And form field userid = userId
    And form field password = password
    And form field v = '1.1'
    And form field name = 'Gupshup'
    And form field recipients = 'CHAITHANYA.KARKERA@GUPSHUP.IO,TEMP1@YOPMAIL.COM,KARKERACHAITHANYA@GMAIL.COM'
    And form field subject = 'Karate Post Campaign Test'
    And form field content = 'Hello from Karate'
    And form field content_type = 'text/html'
    And form field attachment1 = { read: 'classpath:attachments/sample-file.rtf', filename: 'file-sample_500kB.rtf' }
    And form field msg_id = 'msid,msidddd,msgidthreeeee'
    And form field format = 'json'
    And form field extra = 'extra111'
    And form field replyToEmailId = 'info@ecomadminpro.com'
    And form field fromEmailId = 'info@ecomadminpro.com'
    When method POST
    Then status 200
    * def jsonResponse = response
    * print 'EMS_POST_CAMPAIGN response: ' , jsonResponse
    And match response.response.status == 'success'

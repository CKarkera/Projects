Feature: EMS Upload Campaign API

  Background:
    * def newsletterFilePath = 'classpath:Shah_shah_newsletter.zip'
    * def attachmentFilePath = 'classpath:test.pdf'
    * url baseUrl

    # Temporarily hardcode DbUtils instantiation directly here
  # (This bypasses karate-config.js's global setup for 'db')
#    * def appPropertiesForDb = { 'db.url': 'jdbc:mysql://10.232.224.83:3306/EMSGatewayNEW?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC', 'db.username': 'webaroo', 'db.password': 'webar00' }
#    * print 'DB Config:', appPropertiesForDb
#
#    * def DatabaseConfig = Java.type('config.DatabaseConfig')
#    * DatabaseConfig.initialize(appPropertiesForDb)
#    * def db = Java.type('utils.DbUtils')
#
## Test the connection
#    * def testResult = db.executeQuery("SELECT 1 as test")
#    * print 'Database connection test:', testResult
#
#  #Directly define 'db' here
#    * print 'Database utility object:', db
#    # This line should now pass if the above

  @run
  Scenario Outline: Send EMS Upload Campaign Email
#    Given url
    And multipart field method = 'EMS_UPLOAD_CAMPAIGN'
    And multipart field userid = '2000700946'
    And multipart field password = '5zcynM'
    And multipart field v = '1.1'
    And multipart field name = 'QA EMAIL'
    And multipart field subject = 'Automation Upload Campaign API 😀😀😀😀😀'
    And multipart file newsletter_file = { read: #(newsletterFilePath), filename: 'Shah_shah_newsletter.zip', contentType: 'application/zip' }
    And multipart field content_type = 'text/html'
    And multipart field recipients = '<recipient>'
    And multipart field msg_id = '<msgId>'
    And multipart field extra = '<extra>'
    And multipart field format = 'text'
    And multipart field bccEmailId = 'eesho2022.great@gmail.com'
    And multipart field ccEmailId = 'samir.webaroo@yahoo.co.in'
    And multipart field fromEmailId = 'info@ecomadminpro.com'
    And multipart field replyToEmailId = 'info@ecomadminpro.com'
    And multipart file attachment1 = { read: #(attachmentFilePath), filename: 'test.pdf', contentType: 'application/pdf' }
    When method post
    Then status 200
    And print response
    And match response contains 'Campaign posted'
    And match response contains '<msgId>'

     # Extract causeId from API response
    * def causeId = response.response.id
    * print 'causeId from API response:', causeId

    # Construct the SQL query
#    * def query = "select * from EmailSchedulerInfo where causeId = " + causeId + " LIMIT 1"
#    # Execute the query using the 'db' object (which is the DbUtils class)
#    * def results = db.executeQuery(query)
#    * print 'Database query results:', results

#    # Assertions on database results
#    * match results.size() == 1
#    * def scheduledEmailInfo = results[0]
#    * match scheduledEmailInfo.causeId == causeId
#    * match scheduledEmailInfo.subject contains 'Automation API Upload Campaign'

    # Response validation based on format
    * if (format == 'json') match response.response.details contains 'Campaign posted'
    * if (format == 'text') match response == '#string'
    * if (format == 'text') match response contains 'Campaign posted'



    Examples:
      | recipient                       | msgId   | extra                                |
      | karkerachaithanya@gmail.com     | msg001  | extra111111                          |
      | chaithanya.karkera@gupshup.io   | msg002  | extra222222                          |
      | temp1@yopmail.com               | msg003  | extra333333withlongdatatoverifylogic |
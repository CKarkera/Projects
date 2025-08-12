# EMS_Post_Campaign_API_and_DB_Validation.feature
Feature: EMS Post Campaign API and DB Validation

  Background:
    * configure headers = { Cookie: 'rememberMe=false' }
    * def filePath = 'classpath:sample.vcf'
    * url baseUrl
#
#    * def DbUtils = Java.type('utils.DbUtils')
#    * def dbConfig = { url: 'jdbc:mysql://10.232.224.83:3306/EMSGatewayNEW', user: 'webaroo', password: 'webar00' }
#    * def db = new DbUtils(dbConfig.url, dbConfig.user, dbConfig.password)




#    * def baseUrl = karate.properties['baseUrl']
#    * url baseUrl
#    * def config = karate.config
#    * def dbConfig = config.db
#    * def dbUtils = Java.type('utils.DbUtils')
    # use jdbc to validate
#    * def config = { username: 'webaroo', password: 'webar00', url: 'jdbc:mysql://10.232.224.83:3306/EMSGatewayNEW', driverClassName: 'com.mysql.cj.jdbc.Driver' }
#    * def DbUtils = Java.type('utils.DbUtils')
#    * def db = new DbUtils(config)

  @run
  Scenario: Send EMS Post Campaign Email and Validate DB
    # --- Step 1: API Request ---
#    Given url
    And multipart field method = 'EMS_POST_CAMPAIGN'
    And multipart field userid = '2000700946'
    And multipart field password = '5zcynM'
    And multipart field v = '1.1'
    And multipart field name = 'Gupshup'
    And multipart field recipients = 'temp1@yopmail.com'
    And multipart field subject = 'Automation API Post Campaign 😀'
    And multipart field content = 'hiii'
    And multipart field content_type = 'text/html'
    And multipart file attachment1 = { read: #(filePath), filename: 'sample.vcf', contentType: 'text/x-vcard' }
    And multipart field msg_id = 'msid'
    And multipart field format = 'json'
    And multipart field extra = 'extra'
    And multipart field fromEmailId = 'info@ecomadminpro.com'
    And multipart field replyToEmailId = 'info@ecomadminpro.com'
    When method post
    Then status 200
    * def apiResponse = response
    * def causeId = response.response.id
    * print 'Extracted causeId:', causeId


    * def dbQuery = "SELECT * FROM EmailSchedulerInfo WHERE causeId = ' + causeId + ' LIMIT 1'"
    * def dbResult = db.readRow(dbQuery)

    * match apiResponse.id == dbResult.causeId
    * match apiResponse.status == dbResult.status

    * def db.close()

#
#    * def query = db.readRows('SELECT * FROM EmailSchedulerInfo WHERE causeId = ' + causeId + ' LIMIT 1')
#    * match query contains { causeId: '#(causeId)' }

    # --- Step 2: DB Validation ---
#    * def query = 'SELECT * FROM EmailSchedulerInfo WHERE causeId = ' + causeId + ' LIMIT 1'
#    * def dbResult = dbUtils.executeQuery(dbConfig.url, dbConfig.username, dbConfig.password, dbConfig.driverClassName, query)
#    * def dbData = dbResult[0]

    # --- Step 3: Validate DB Against API ---
#    * match apiResponse.id == dbData.causeId
#    * match dbData.subject contains 'Automation API Post Campaign'
#    * match dbData.recipients contains 'temp1@yopmail.com'
#    * match dbData.fromEmailId == 'info@ecomadminpro.com'







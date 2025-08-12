Feature: Email Campaign API with End-to-End Database Validation

  Background:
    * url baseUrl
    * def config = karate.call('classpath:karate-config.js')
    * def dbConfig = config.db
    * def gatewayDbConfig = config.gatewayDb
    * def testData = config.testData
    * def queries = config.queries
    * def utils = config.utils

  # Generate unique test identifiers
    * def uniqueId = utils.generateUniqueId()
    * def testMsgId = 'test_msg_' + uniqueId
    * def testCampaignName = 'Karate_Test_' + uniqueId

  # Enhanced Test Data Setup with unique values
    * def campaignData =
    """
    {
      method: 'EMS_POST_CAMPAIGN',
      userid: '#(testData.validUser.userid)',
      password: '#(testData.validUser.password)',
      v: '1.1',
      name: '#(testCampaignName)',
      recipients: 'CHAITHANYA.KARKERA@gupshup.io,TEMP1@YOPMAIL.COM',
      subject: 'Karate Automation Test - Campaign API Validation - #(uniqueId)',
      content: 'This is an automated test campaign created by Karate framework for end-to-end validation',
      content_type: 'text/html',
      msg_id: '#(testMsgId)',
      format: 'json',
      extra: 'karate_test_extra_data_validation_#(uniqueId)',
      replyToEmailId: 'info@ecomadminpro.com',
      fromEmailId: 'info@ecomadminpro.com'
    }
    """

  Scenario: Primary Database Connection Validation
    Given def DbUtils = Java.type('com.intuit.utils.DbUtils')
    When def connection = DbUtils.getConnection(dbConfig.url, dbConfig.username, dbConfig.password)
    Then assert connection != null
    And print 'Primary database connection established successfully'

  # Test basic connectivity with system query
    * def result = karate.call('classpath:helpers/db-query.js', { config: dbConfig, query: 'SELECT VERSION() as db_version, NOW() as current_time' })
    * match result.db_version == '#string'
    * match result.current_time == '#string'
    * print 'Database version:', result.db_version
    * print 'Database connectivity test passed'

  # Validate required tables exist
    * def tableCheckQueries = ['SELECT 1 FROM campaigns LIMIT 1', 'SELECT 1 FROM users LIMIT 1', 'SELECT 1 FROM audit_log LIMIT 1']
    * def tableResults = karate.map(tableCheckQueries, function(query) { return karate.call('classpath:helpers/db-query.js', { config: dbConfig, query: query }) })
    * print 'All required tables are accessible'

  # Close connection
    * eval DbUtils.closeConnection(connection)

  Scenario: Gateway Database Connection Validation
    Given def DbUtils = Java.type('com.intuit.karate.demo.DbUtils')
    When def gatewayConnection = DbUtils.getConnection(gatewayDbConfig.url, gatewayDbConfig.username, gatewayDbConfig.password)
    Then assert gatewayConnection != null
    And print 'Gateway database connection established successfully'

  # Test gateway database connectivity
    * def gatewayResult = karate.call('classpath:helpers/db-query.js', { config: gatewayDbConfig, query: 'SELECT COUNT(*) as total_records FROM information_schema.tables' })
    * match gatewayResult.total_records == '#number'
    * print 'Gateway database table count:', gatewayResult.total_records

  # Close connection
    * eval DbUtils.closeConnection(gatewayConnection)

  Scenario: Pre-API Database State Validation and Setup
  # Validate user credentials and permissions
    * def userValidationQuery = 'SELECT userId, causeId, status FROM EmailSchedulerInfo WHERE causeId= "' + campaignData.id + '" AND status = "success"'
    * def userResult = karate.call('classpath:helpers/db-query.js', { config: dbConfig, query: userValidationQuery })
    * match userResult.userid == campaignData.userid
    * match userResult.status == 'ACTIVE'
    * print 'User validation passed for userid:', userResult.userid

  # Get baseline campaign count for validation
    * def campaignCountQuery = 'SELECT COUNT(*) as count FROM Campaign'
    * def campaignCountBefore = karate.call('classpath:helpers/db-query.js', { config: dbConfig, query: campaignCountQuery })
    * def baselineCampaignCount = campaignCountBefore.count
    * print 'Baseline campaign count:', baselineCampaignCount

  # Check for any existing campaigns with same msg_id (should be none)
    * def duplicateCheckQuery = 'SELECT COUNT(*) as count FROM Campaign WHERE id = "' + campaignData.id + '"'
    * def duplicateResult = karate.call('classpath:helpers/db-query.js', { config: dbConfig, query: duplicateCheckQuery })
    * match duplicateResult.count == 0
    * print 'Confirmed no duplicate msg_id exists'

#  # Validate email queue is accessible
#    * def emailQueueQuery = 'SELECT COUNT(*) as queue_count FROM email_queue WHERE status = "PENDING"'
#    * def emailQueueBefore = karate.call('classpath:helpers/db-query.js', { config: dbConfig, query: emailQueueQuery })
#    * def baselineQueueCount = emailQueueBefore.queue_count
#    * print 'Baseline email queue count:', baselineQueueCount.js', { config: db, query: 'SELECT COUNT(*) as count FROM Campaign' })
#    * print 'Campaign count before API call:', campaignCountBefore.count

  Scenario: Email Campaign API Test with Database Validation
    Given multipart form data campaignData
    When method POST
    Then status 200
    And print 'API Response:', response

  # Validate API Response Structure
    * match response.response.status == 'success'
    * match response.response.details == 'Campaign posted'
    * match response.response.msgId == campaignData.msg_id
    * match response.response.id == '#string'
    * match response.response.phone == ''

  # Store campaign ID for database validation
    * def campaignId = response.response.id
    * print 'Generated Campaign ID:', campaignId

  # Database Validation - Check if campaign was inserted
    * def db = karate.get('dbConfig')
    * def campaignQuery = 'SELECT * FROM campaigns WHERE campaign_id = "' + campaignId + '"'
    * def dbResult = karate.call('classpath:helpers/db-query.js', { config: db, query: campaignQuery })
    * print 'Database campaign record:', dbResult

  # Validate database record matches API request data
    * match dbResult.user_id == campaignData.userid
    * match dbResult.campaign_name == campaignData.name
    * match dbResult.subject == campaignData.subject
    * match dbResult.content == campaignData.content
    * match dbResult.recipients == campaignData.recipients
    * match dbResult.status == 'POSTED'

  # Check campaign count increased by 1
    * def campaignCountAfter = karate.call('classpath:helpers/db-query.js', { config: db, query: 'SELECT COUNT(*) as count FROM Campaign' })
    * def expectedCount = campaignCountBefore.count + 1
    * match campaignCountAfter.count == expectedCount



  Scenario: Post-API Database Cleanup and Validation
    Given def db = karate.get('dbConfig')

  # Optional: Clean up test data (uncomment if needed)
  # * def cleanupQuery = 'DELETE FROM campaigns WHERE msg_id = "' + campaignData.msg_id + '"'
  # * def cleanupResult = karate.call('classpath:helpers/db-query.js', { config: db, query: cleanupQuery })

  # Validate specific campaign details in database
    * def detailQuery = 'SELECT campaign_id, user_id, status, created_at FROM campaigns WHERE msg_id = "' + campaignData.msg_id + '"'
    * def detailResult = karate.call('classpath:helpers/db-query.js', { config: db, query: detailQuery })
    * print 'Final campaign details:', detailResult

  # Close database connection
    * print 'Database validation completed successfully'

  Scenario: Negative Test - Invalid User Database Validation
    Given multipart form data campaignData
    * set campaignData.userid = 'INVALID_USER_ID'
    When method POST
    Then status 400

  # Validate no database entry was created for invalid request
    * def db = karate.get('dbConfig')
    * def invalidUserQuery = 'SELECT COUNT(*) as count FROM campaigns WHERE user_id = "INVALID_USER_ID"'
    * def invalidResult = karate.call('classpath:helpers/db-query.js', { config: db, query: invalidUserQuery })
    * match invalidResult.count == 0
    * print 'Confirmed: No database entry for invalid user'
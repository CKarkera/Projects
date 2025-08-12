  #----------- Auth token api features----------------------
  Feature: EMS POST CAMPAIGN API Testing with Karate

    Background:
      * url 'https://enterprise-qa.webaroo.com/GatewayAPI/rest'
      * def authResponse = callonce read('classpath:api/auth-create.feature')
      * def authToken = authResponse.token
      * def baseUrl = 'https://enterprise-qa.webaroo.com/GatewayAPI/rest'

    @EMSPostCampaign
    Scenario: Post Email Campaign with Authentication Token
      Given url baseUrl
      And multipart form data
        | field          | value                                                                                                |
        | method         | EMS_POST_CAMPAIGN                                                                                    |
        | userid         | 2000700946                                                                                           |
        | password       | 5zcynM                                                                                               |
        | v              | 1.1                                                                                                  |
        | name           | Gupshup                                                                                              |
        | recipients     | CHAITHANYA.KARKERA@dummyhit.com,TEMP1@YOPMAIL.COM,KARKERACHAITHANYA@dummyhit.com                     |
        | subject        | Karate_Script for API  Post Campaign 😀__😀 😀   EM QA POST CAMP API 😀 😀 😀 😀                     |
        | content        | hiii                                                                                                 |
        | content_type   | text/html                                                                                            |
        | msg_id         | msid,msidddd,msgidthreeeee                                                                           |
        | format         | json                                                                                                 |
        | extra          | extra111111extra111111extra111111extra111111extra111111extra111111extrextra111111extra111111extra111 |
        | replyToEmailId | info@ecomadminpro.com                                                                                |
        | fromEmailId    | info@ecomadminpro.com                                                                                |
      And multipart file attachment1 = { read: 'classpath:testdata/file-sample_500kB.rtf', filename: 'file-sample_500kB.rtf', contentType: 'application/rtf' }
      And header Authorization = 'Bearer ' + authToken
      When method post
      Then status 200
      And match response.status == 'success'
      And match response contains { campaign_id: '#string' }
      And print 'Campaign posted successfully with ID:', response.campaign_id

    @EMSPostCampaignValidation
    Scenario: Validate EMS POST CAMPAIGN Response Structure
      Given url baseUrl
      And multipart form data
        | field        | value                             |
        | method       | EMS_POST_CAMPAIGN                 |
        | userid       | 2000700946                        |
        | password     | 5zcynM                            |
        | v            | 1.1                               |
        | name         | Test Campaign Validation          |
        | recipients   | CHAITHANYA.KARKERA@GUPSHUP.IO     |
        | subject      | Test Email Campaign Subject       |
        | content      | Test email content for validation |
        | content_type | text/html                         |
        | format       | json                              |
        | fromEmailId  | info@ecomadminpro.com             |
      And header Authorization = 'Bearer ' + authToken
      When method post
      Then status 200
      And match response ==
    """
    {
      status: '#string',
      message: '#string',
      campaign_id: '#string',
      timestamp: '#string'
    }
    """
      And match response.status == 'success'
      And assert response.campaign_id.length > 0

    @EMSPostCampaignWithVariables
    Scenario: Post Campaign using Variables and Data-driven approach
      * def campaignData =
    """
    {
      method: 'EMS_POST_CAMPAIGN',
      userid: '2000700946',
      password: '5zcynM',
      version: '1.1',
      campaignName: 'Automated Test Campaign',
      recipientsList: 'CHAITHANYA.KARKERA@dummyhit.com,TEMP1@YOPMAIL.COM',
      emailSubject: 'Karate Automated Test Campaign 🚀',
      emailContent: '<h1>Hello from Karate Automation!</h1><p>This is a test email.</p>',
      contentType: 'text/html',
      messageIds: 'auto-msg-001,auto-msg-002,auto-msg-003',
      responseFormat: 'json',
      extraData: 'karate-automation-extra-data-12345',
      replyEmail: 'info@ecomadminpro.com',
      senderEmail: 'info@ecomadminpro.com'
    }
    """

      Given url baseUrl
      And multipart form data
        | field          | value                          |
        | method         | #(campaignData.method)         |
        | userid         | #(campaignData.userid)         |
        | password       | #(campaignData.password)       |
        | v              | #(campaignData.version)        |
        | name           | #(campaignData.campaignName)   |
        | recipients     | #(campaignData.recipientsList) |
        | subject        | #(campaignData.emailSubject)   |
        | content        | #(campaignData.emailContent)   |
        | content_type   | #(campaignData.contentType)    |
        | msg_id         | #(campaignData.messageIds)     |
        | format         | #(campaignData.responseFormat) |
        | extra          | #(campaignData.extraData)      |
        | replyToEmailId | #(campaignData.replyEmail)     |
        | fromEmailId    | #(campaignData.senderEmail)    |
      And header Authorization = 'Bearer ' + authToken
      When method post
      Then status 200
      And def campaignId = response.campaign_id
      And print 'Campaign created with ID:', campaignId
      * karate.set('globalCampaignId', campaignId)

    @EMSPostCampaignErrorHandling
    Scenario Outline: Test EMS POST CAMPAIGN with Invalid Data
      Given url baseUrl
      And multipart form data
        | field        | value                 |
        | method       | EMS_POST_CAMPAIGN     |
        | userid       | <userid>              |
        | password     | <password>            |
        | v            | 1.1                   |
        | name         | Error Test Campaign   |
        | recipients   | <recipients>          |
        | subject      | Error Test Subject    |
        | content      | Error test content    |
        | content_type | text/html             |
        | format       | json                  |
        | fromEmailId  | info@ecomadminpro.com |
      And header Authorization = 'Bearer ' + authToken
      When method post
      Then status <expectedStatus>
      And match response.status == '<expectedResponse>'

      Examples:
        | userid     | password | recipients           | expectedStatus | expectedResponse |
        | 2000700946 | wrong    | test@dummyhit.com    | 401            | error            |
        | wrong      | 5zcynM   | test@dummyhit.com    | 401            | error            |
        | 2000700946 | 5zcynM   | invalid-email-format | 400            | error            |

    @EMSPostCampaignCleanup
    Scenario: Cleanup - Store Campaign Details for Future Reference
      * def testResults =
    """
    {
      timestamp: '#(java.time.Instant.now())',
      campaignId: '#(karate.get('globalCampaignId'))',
      testStatus: 'completed',
      environment: 'test'
    }
    """
      * print 'Test execution completed:', testResults
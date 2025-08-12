Feature: EMS Upload Campaign to Uploaded Addresses

  Background:
    * url 'https://enterprise-qa.webaroo.com/GatewayAPI/rest'
    * def recipientsFile = 'classpath:Recipient_Custom_Bulk.csv'
    * def newsletterFile = 'classpath:Shah_shah_newsletter.zip'
    * def attachment1 = 'classpath:sample.pdf'
    * configure headers = { Cookie: 'rememberMe=false' }
    * def config = call read('classpath:config/PropertyReader.js')

  @regression
  Scenario Outline: Send EMS Upload Campaign with multiple formats
    Given multipart field method = 'EMS_UPLOAD_CAMPAIGN_TO_UPLOADED_ADDRESSES'
    And multipart field userid = '2000700946'
    And multipart field password = '5zcynM'
    And multipart field v = '1.1'
    And multipart field name = '<name>'
    And multipart field subject = '<subject>'
    And multipart field content_type = 'text/html'
    And multipart file recipients_file = { read: #(recipientsFile), filename: 'Recipient_Custom_Bulk.csv', contentType: 'text/csv' }
    And multipart file newsletter_file = { read: #(newsletterFile), filename: 'Shah_shah_newsletter.zip', contentType: 'application/zip' }
    And multipart file attachment1 = { read: #(attachment1), filename: 'sample.pdf', contentType: 'application/pdf' }
    And multipart field content = 'Hi ${name}, Your OTP is ${mobile} Thank you'
    And multipart field format = '<format>'
    And multipart field fromEmailId = 'info@ecomadminpro.com'
    And multipart field replyToEmailId = 'info@ecomadminpro.com'
    When method post
    Then status 200
    And print response

    Examples:
      | name              | format |subject|
      | API_Test_User1    | json   |Automation API 😀 Testing EMS_UPLOAD_CAMPAIGN_TO_UPLOADED_ADDRESSES!!|
      | QA_Email_User2    | xml    |Automation API 😀 API REQUEST EMS_UPLOAD_CAMPAIGN_TO_UPLOADED_ADDRESSES|
      | AutomationUser3   | text   |Automation API 😀 EMS_UPLOAD_CAMPAIGN_TO_UPLOADED_ADDRESSES 😀|

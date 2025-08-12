Feature: EMS Post Campaign to Uploaded Addresses API

  Background:
    * url 'https://enterprise-qa.webaroo.com/GatewayAPI/rest'
    * def recipientsFile = 'classpath:EmailIDListUpload.csv'
    * def attachment1 = 'classpath:images.png'
    * configure headers = { Cookie: 'rememberMe=false' }

@regression
  Scenario Outline: Send EMS Post Campaign to Uploaded Addresses with dynamic variables
    Given multipart field method = 'EMS_POST_CAMPAIGN_TO_UPLOADED_ADDRESSES'
    And multipart field userid = '2000700946'
    And multipart field v = '1.1'
    And multipart field format =  '<format>'
    And multipart field name = '<name>'
    And multipart field subject = 'Automation 😀 EMS_POST_CAMPAIGN_TO_UPLOADED_ADDRESSES!'
    And multipart field content = 'Hi <name>, Your OTP is <mobile> Thank you. आपका दिन शुभ हो!@#$%^*(),.?/:;\'"{}[]\|#&_+'
    And multipart field content_type = 'text/html'
    And multipart field replyToEmailId = 'info@ecomadminpro.com'
    And multipart file recipients_file = { read: #(recipientsFile), filename: 'EmailIDListUpload.csv', contentType: 'text/csv' }
    And multipart file attachment1 = { read: #(attachment1), filename: 'images.png', contentType: 'image/png' }
    And multipart field fromEmailId = 'info@ecomadminpro.com'
    And multipart field password = '5zcynM'
    When method post
    Then status 200
    And print response


 # Response validation based on format
  * if (format == 'json') karate.match(response.response.details, 'Campaign posted').pass
  * if (format == 'text') karate.match(response, '#string').pass
  * if (format == 'text') karate.match(response.includes('Campaign posted'), true)

  Examples:
    | name          | format |
    | Gupshup       | json   |
    | Gupshup_XML   | xml    |
    | Gupshup_Text  | text   |

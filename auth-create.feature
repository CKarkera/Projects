@createtoken
Feature: Create token
  Scenario:
    * url 'https://enterprise-qa.webaroo.com/GatewayAPI'
    * path '/api/auth/create'
    * request { webRequest: false, userId: 2000700946, password: '5zcynM', tokenValidity: 3600 }
    * method post
    * status 200

Feature: DB Utility Example
  Background:

    * def config = { username: 'webaroo', password: 'webar00', url: 'jdbc:mysql://10.232.224.83:3306/EMSGatewayNEW?allowPublicKeyRetrieval=true&useSSL=false', driverClassName: 'com.mysql.cj.jdbc.Driver' }
    * def DBUtils = Java.type('utils.DbUtils')
    * def db = new DBUtils(config)

  @dbtest
  Scenario: Read a row from the database
    # Example query to fetch latest record from EmailSchedulerInfo
    * def result = db.readRow("SELECT * FROM EmailSchedulerInfo ORDER BY causeId DESC LIMIT 1")
    * print result

#    # You can assert something from the row
#    * match result != null


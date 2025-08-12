Feature: Verify config is loaded
@sanfea
  Scenario: Check DB config loaded
    * def config = karate.config
    * print '✅ Loaded config:', config
    * match config != null
    * match config.db.url contains 'jdbc:mysql://10.232.224.83:3306/EMSGatewayNEW'

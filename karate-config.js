function fn() {
  var env = karate.env || 'qa';
  karate.log('Running in QA environment', env);

  var config = {
    baseUrl: 'https://enterprise-qa.webaroo.com/GatewayAPI/rest',
    db: {
      url: 'jdbc:mysql://10.232.224.83:3306/EMSGatewayNEW',
      username: 'webaroo',
      password: 'webar00',
      driverClassName: 'com.mysql.cj.jdbc.Driver'
    }
  };
  karate.log('✅ Config initialized:', config);
  return config;
}

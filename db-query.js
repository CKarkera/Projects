//// helpers/db-query.js
//// Database helper function for Karate tests
//
//function(config) {
//  var DbUtils = Java.type('com.intuit.karate.demo.DbUtils');
//  var connection = null;
//  var result = null;
//
//  try {
//    // Establish database connection
//    connection = DbUtils.getConnection(config.config.url, config.config.username, config.config.password);
//    karate.log('Database connection established');
//
//    // Execute query
//    var statement = connection.createStatement();
//    var resultSet = statement.executeQuery(config.query);
//
//    // Process result set
//    var results = [];
//    var metaData = resultSet.getMetaData();
//    var columnCount = metaData.getColumnCount();
//
//    while (resultSet.next()) {
//      var row = {};
//      for (var i = 1; i <= columnCount; i++) {
//        var columnName = metaData.getColumnName(i);
//        var value = resultSet.getObject(i);
//        row[columnName.toLowerCase()] = value;
//      }
//      results.push(row);
//    }
//
//    resultSet.close();
//    statement.close();
//
//    // Return single object if only one row, otherwise return array
//    result = results.length === 1 ? results[0] : results;
//
//    karate.log('Database query executed successfully. Rows returned: ' + results.length);
//
//  } catch (e) {
//    karate.log('Database error: ' + e.message);
//    throw new Error('Database operation failed: ' + e.message);
//  } finally {
//    if (connection) {
//      try {
//        connection.close();
//        karate.log('Database connection closed');
//      } catch (e) {
//        karate.log('Error closing connection: ' + e.message);
//      }
//    }
//  }
//
//  return result;
//}
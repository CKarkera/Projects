(function() {
  var propertiesText = karate.read('classpath:config/application.properties');
  var config = {};

  var lines = propertiesText.split('\n');
  for (var i = 0; i < lines.length; i++) {
    var line = lines[i].trim();
    if (line && !line.startsWith('#') && !line.startsWith('//')) {
      var separatorIndex = line.indexOf('=');
      if (separatorIndex > 0) {
        var key = line.substring(0, separatorIndex).trim();
        var value = line.substring(separatorIndex + 1).trim();

        if ((value.startsWith('"') && value.endsWith('"')) ||
            (value.startsWith("'") && value.endsWith("'"))) {
          value = value.substring(1, value.length - 1);
        }

        config[key] = value;
      }
    }
  }
  return config;
})();


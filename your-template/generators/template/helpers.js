module.exports = function(Handlebars){
  Handlebars.registerHelper('camelize', (function() {
    var camelize = function(string) {
      var regexp = /[-_]([a-z\d])/g;
      var rest = string.replace(regexp, function(match, char) {
        return char.toUpperCase();
      });
      return rest[0].toUpperCase() + rest.slice(1);
    };
    return function(options) {
      return new Handlebars.SafeString(camelize(options.fn(this)));
    };
  })());
}

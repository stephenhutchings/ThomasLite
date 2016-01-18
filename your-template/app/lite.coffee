load = (name, path, apikey, done) ->
  fullPath = "#{path}#{name}"
  fullPath += "?key=#{apikey}" if apikey?

  if /\.js$/.test name
    el = document.createElement("script")
    el.setAttribute("type", "text/javascript")
    el.setAttribute("src", fullPath)

  else if /\.css$/.test name
    el = document.createElement("link")
    el.setAttribute("rel", "stylesheet")
    el.setAttribute("type", "text/css")
    el.setAttribute("href", fullPath)

  el.addEventListener "load", done
  document.getElementsByTagName("head")[0].appendChild(el)

Lite =
  initialize: (apikey) ->
    from = if apikey then "https://thomaslite.edapp.com/" else ""
    files = [
      "css/app.css"
      "js/vendor.js"
      "js/app.js"
    ]

    do next = ->
      if files.length
        file = files.shift()
        load file, from, apikey, next
      else
        new (require "lib/logger")(true, "THOMAS", "#46B4E9") "Hello!"
        require("app").initialize()

module.exports = Lite

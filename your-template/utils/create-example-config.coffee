_      = require "lodash"
deep   = require "deep-extend"
fs     = require "fs"
logger = require "loggy"
yaml   = require "js-yaml"

defaultConfig  = "utils/default.yaml"
templatesDir   = "app/engine"
configJsonFile = "build/config.json"

logger.info "created `config.json` from template models"

defaults = ->
  yaml.load fs.readFileSync(defaultConfig, "UTF-8")

model = (template) ->
  yaml.load fs.readFileSync("#{templatesDir}/#{template}/model.yaml", "UTF-8")

templates = ->
  fs.readdirSync(templatesDir).filter (f) -> not f.match /\./

data = (model) ->
  result = {}
  for prop, val of model
    if _.isString(val)
      val
    else if val.type?
      if _.isArray(val.default)
        result[prop] = _.compact(val.default)
      else
        result[prop] = val.default
    else if _.isArray(val)
      result[prop] = val.map(data)
    else
      result[prop] = data(val)

  result

config = (model) ->
  defaultData = data(model.model)
  if model.examples?
    model.examples.map (d, i) ->
      name: "#{model.title}-#{i}"
      type: model.title
      data: deep({}, defaultData, d)
  else
    name: model.title
    type: model.title
    data: defaultData

jsonConfig = ->
  _.extend {}, defaults(),
    slides:
      _.chain(templates())
        .map(model)
        .map(config)
        .flatten()
        .sortBy( (a, b) ->
          order = ["title", "image", "pie-chart", "strikeout"]
          a = order.indexOf(a.type)
          b = order.indexOf(b.type)
          a - b
        )
        .value()

fs.writeFileSync configJsonFile, JSON.stringify(jsonConfig(), null, "\t")

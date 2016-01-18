### Thomas Templates

#### Generators

Generate a new template using [scaffolt].

```bash
scaffolt template your-template-name
```

This will create:
  - `app/engine/your-templates-name/view.coffee`
  - `app/engine/your-templates-name/template.jade`
  - `app/engine/your-templates-name/_style.sass`
  - `app/engine/your-templates-name/model.yaml`

You'll need to add a reference to the `sass` file in `app.sass` to have it added to your deck.

[scaffolt]: https://github.com/paulmillr/scaffolt

#### Engine Models

Models are [YAML] files that describe the data structure of a template.

They must declare some properties at the top level:

```yaml
title: "name-of-template"
display: "Name of Template"
model:
  property:
    type: "text"
    etc..
```

The display property is used to by the CMS in place of the title field.

Each property in the model's description takes the following structure, depending on it's type:

```yaml
textExample:
  type:     "text"
  default:  "Default text"
  display:  "Text Example"

arrayExample:
  type:
    - "Content"

  display: "Array Example"
  min:     0
  max:     99

numberExample:
  type:    "number"
  display: "Number Example"
  default: 0
  min:     0
  max:     99

integerExample:
  type:    "int"
  display: "Integer Example"
  default: 0
  min:     0
  max:     99

booleanExample:
  type:    "boolean"
  display: "Boolean Example"
  default: true

```

[YAML]: http://www.yaml.org/start.html

#### Engine Views

Every template is driven by a Backbone view. It's got an events hash and all of the other goodies from [Backbone].

If a model declares an `answer` property, the view should declare an `isCorrect` method (used when displaying the answer). This should return a boolean based on the user's interaction. For example, the multiple choice game confirms that the number of active, correct selectable answers matches the total number of correct answers.

```coffee
isCorrect: ->
  _(@getEl("answers"))
    .filter((el) -> el.classList.contains("correct"))
    .difference(@getEl("selected"))
    .isEmpty()
```

[Backbone]: http://backbonejs.org/

#### Engine Templates

Engine templates render the model's data, ready for the user's interaction. Templates are [Jade] compiled into Javacript functions. They are rendered with the model's data as locals. [`moment`], [`_`], [`Big`], [`written`] and [`typogr`] are available globally in all templates.

[Jade]: http://jade-lang.com/
[`_`]: https://lodash.com/
[`moment`]: http://momentjs.com/
[`Big`]: https://github.com/MikeMcl/big.js/
[`typogr`]: https://github.com/ekalinin/typogr.js
[`written`]: https://github.com/stephenhutchings/written

#### Engine Styles

Engine styles determine specific styles for a template, scoped to slides with a matching class name. It's important to leave this scoping in place, otherwise styles may creep into other slides unintentionally. Thomas requires styles to be added as [SASS], rather than `scss` files. It's syntax matches nicley with the other languages in play.

[SASS]: http://sass-lang.com

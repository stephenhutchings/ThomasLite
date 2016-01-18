## Thomas Lite

Thomas Lite is a tool to develop slide templates for Ed.

### Requirements

Thomas requires access to Ed's development environment.

You will also need [Node], [Brunch] and [Bower] installed on your machine. [Scaffolt] is optional, but is useful if creating a lot of templates.

### Running Thomas Lite

You can clone Thomas Lite using brunch. This will run `npm install` and `bower install` for you.

```
brunch new https://github.com/Creative-Licence-Digital/ThomasLite.git your-template
```

Now you are ready to run Thomas...

```
brunch w -s
```

Access Thomas on `localhost:3333`. Thomas watches for any changes you make and reloads the page.

### More information

- [Templates](docs/Templates.md) documents the different files needed by a
  template and how to create new templates.

- [Slide Methods](docs/Slide Methods.md) give an overview of common methods
  made available to every template view.

- [DOM Structure](docs/DOM Structure.md) shows an overview of how Thomas is
  structured.

- **CSS components** provide highly abstracted styles to avoid repetitive CSS
  declarations bloating the core CSS framework. Always check whether a class
  aleady exists, and use these styles to help maintain a lightweight codebase.
  - [Blocks](docs/css/Blocks.md)
  - [Grids](docs/css/Grids.md)
  - [Content Alignment](docs/css/Content Alignment.md)
  - [Typography](docs/css/Typography.md)
  - [Animations and Transitions](docs/css/Animations and Transitions.md)

- **JS libraries** provide core functionality in a modular and re-useable
  format. Like Thomas's CSS, use pre-existing modules when appropriate.
  - [Device](docs/js/Device.md)
  - [DraggyView](docs/js/DraggyView.md)
  - [Easie](docs/js/Easie.md)
  - [Prefix](docs/js/Prefix.md)
  - [Preload](docs/js/Preload.md)
  - [Style](docs/js/Style.md)

[Node]: https://nodejs.org/en/
[Brunch]: http://brunch.io
[Bower]: http://bower.io/
[Scaffolt]: https://github.com/paulmillr/scaffolt

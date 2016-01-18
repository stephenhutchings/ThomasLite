### Blocks

Blocks provide a highly abstracted layout component, allowing for consistent spacing across templates and screen sizes.

Spacing blocks add padding on either all sides, top and bottom or left and right. They come in four sizes, which change padding depending on the screen with. The following spacing blocks are available.

```css
/* All sides */
.block-sm, .block-md, .block-lg, .block-xl

/* Top and bottom */
.block-ver-sm, .block-ver-md, .block-ver-lg, .block-ver-xl

/* Left and right */
.block-hor-sm, .block-hor-md, .block-hor-lg, .block-hor-xl
```

Flex blocks are useful for centering content of an indiscriminate size within a container.

```css
/* Center child both vertically and horizontally */
.block-flex-center

/* Center child vertically */
.block-flex-ver

/* Center child horizontally */
.block-flex-hor

/* Child class */
.block-flex-child
```

![Blocks](../img/blocks.png)

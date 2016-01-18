### Animations and Transitions

#### Entering the screen

There are several ready-made classed if you want content to transition into the screen smoothly when a user goes to your template.

```css
/* Fade in and slide... */
.slide-up
.slide-down
.slide-left
.slide-right

/* Fade in and scale... */
.scale-up
.scale-down

/* Just fade in... */
.fade-in
```

#### Animations

There are four in-built animation classes, which are useful for demonstrating positive or negative feedback to user responses. These animations should be applied with classes after the user has made some sort of interaction.

```css
@keyframes shake
@keyframes rubber
@keyframes bounce-out
@keyframes pulse

.example-class {
  animation: shake 600ms 1
}
```

#### Delays

If you want to delay any of these transitions or animations, there are 10 `.delay-` classes that increment transition delays by 100ms.

```css
.delay-1, .delay-2, .delay-3, .delay-4 ... .delay-10
```

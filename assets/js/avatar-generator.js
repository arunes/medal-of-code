import { createAvatar } from "@dicebear/core";
import { shapes, bottts } from "@dicebear/collection";

window.addEventListener("moc:set_medal", (event) => {
  const elm = event.target;

  const avatar = createAvatar(shapes, {
    seed: elm.alt,
    size: elm.width,
    shape1Color: [elm.getAttribute("data-colors-1")],
    shape2Color: [elm.getAttribute("data-colors-2")],
    shape3Color: [elm.getAttribute("data-colors-3")],
    backgroundColor: [elm.getAttribute("data-colors-bg")],
  }).toDataUri();

  elm.src = avatar;
});

window.addEventListener("moc:set_avatar", (event) => {
  const elm = event.target;

  const avatar = createAvatar(bottts, {
    seed: elm.alt,
    size: elm.width,
  }).toDataUri();

  elm.src = avatar;
});

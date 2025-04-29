import { createAvatar } from "@dicebear/core";
import { shapes as medals, bottts as avatars } from "@dicebear/collection";

// converts iso date to user's local date
class MOCLocalDatetime extends HTMLElement {
  static get observedAttributes() {
    return ["iso-datetime"];
  }

  attributeChangedCallback(name, _oldValue, newValue) {
    ({
      "iso-datetime": (newValue) => {
        const utc = new Date(newValue);
        this.innerHTML = utc.toLocaleString();
      },
    })[name](newValue);
  }
}

window.customElements.define("moc-local-datetime", MOCLocalDatetime);

// converts iso date to user's local date
class MOCAvatar extends HTMLElement {
  constructor() {
    super();

    const avatar = createAvatar(avatars, {
      seed: this.getAttribute("name"),
      size: this.getAttribute("size"),
    }).toDataUri();

    const img = document.createElement("img");
    img.src = avatar;
    img.className = this.getAttribute("class");
    this.appendChild(img);
  }
}

window.customElements.define("moc-avatar", MOCAvatar);

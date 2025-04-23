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

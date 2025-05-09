import { createAvatar } from "@dicebear/core";
import { shapes as medals, bottts as avatars } from "@dicebear/collection";
import CalHeatmap from "cal-heatmap";
import LegendLite from "cal-heatmap/plugins/LegendLite";
import Tooltip from "cal-heatmap/plugins/Tooltip";
import CalendarLabel from "cal-heatmap/plugins/CalendarLabel";
import WordCloud from "../vendor/wordcloud2";

// converts iso date to user's local date
class MOCLocalDatetime extends HTMLElement {
  static get observedAttributes() {
    return ["iso-datetime"];
  }

  attributeChangedCallback(name, _oldValue, newValue) {
    ({
      "iso-datetime": (newValue) => {
        const format = this.getAttribute("format");
        const utc = new Date(newValue);
        let dateStr = "";

        switch (format) {
          case "date":
            dateStr = utc.toLocaleDateString();
            break;

          case "time":
            dateStr = utc.toLocaleTimeString();
            break;

          default:
          case "datetime":
            dateStr = utc.toLocaleString();
            break;
        }
        this.innerHTML = dateStr;
      },
    })[name](newValue);
  }
}

window.customElements.define("moc-local-datetime", MOCLocalDatetime);

// renders user avatar
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

// Renders a github like contributions calendar
class MOCContributionCalendar extends HTMLElement {
  constructor() {
    super();

    const cal = new CalHeatmap();
    const id = this.getAttribute("id");
    const contributor_id = this.getAttribute("contributor_id");

    const div = document.createElement("div");
    div.id = `${id}-calendar`;
    div.className = this.getAttribute("class");
    this.appendChild(div);

    const dataSource = contributor_id
      ? `/api/contributors/${contributor_id}/activity`
      : "/api/contributors/activity";
    cal.paint(
      {
        theme: localStorage.theme === "dark" ? "dark" : "light",
        itemSelector: `#${div.id}`,
        date: { start: new Date("2024-06-01") },
        data: {
          source: dataSource,
          x: "date",
          y: "count",
        },
        range: 12,
        scale: {
          color: {
            type: "threshold",
            range: ["#14432a", "#166b34", "#37a446", "#4dd05a"],
            domain: [1, 2, 3, 4],
          },
        },
        domain: {
          type: "month",
          gutter: 1,
          label: { text: "MMM", textAlign: "start", position: "top" },
        },
        subDomain: {
          type: "ghDay",
          radius: 0,
          width: 17,
          height: 17,
          gutter: 1,
        },
      },
      [
        [
          Tooltip,
          {
            text: function (date, value, dayjsDate) {
              return (
                (value ? value : "No") +
                " contributions on " +
                dayjsDate.format("dddd, MMMM D, YYYY")
              );
            },
          },
        ],
        [
          LegendLite,
          {
            includeBlank: true,
            itemSelector: "#ex-ghDay-legend",
            radius: 2,
            width: 11,
            height: 11,
            gutter: 4,
          },
        ],
        [
          CalendarLabel,
          {
            width: 30,
            textAlign: "start",
            text: () =>
              dayjs.weekdaysShort().map((d, i) => (i % 2 == 0 ? "" : d)),
            padding: [25, 0, 0, 0],
          },
        ],
      ],
    );
  }
}

window.customElements.define(
  "moc-contribution-calendar",
  MOCContributionCalendar,
);

// renders medal
class MOCMedal extends HTMLElement {
  constructor() {
    super();

    const avatar = createAvatar(medals, {
      seed: this.getAttribute("name"),
      size: this.getAttribute("size"),
      shape1Color: [this.getAttribute("colors-1")],
      shape2Color: [this.getAttribute("colors-2")],
      shape3Color: [this.getAttribute("colors-3")],
      backgroundColor: [this.getAttribute("colors-bg")],
    }).toDataUri();

    const img = document.createElement("img");
    img.src = avatar;
    img.style.borderTop = `7px solid #${this.getAttribute("colors-1")}`;
    img.style.borderLeft = `7px solid #${this.getAttribute("colors-1")}`;
    img.style.borderRight = `7px solid #${this.getAttribute("colors-2")}`;
    img.style.borderBottom = `7px solid #${this.getAttribute("colors-2")}`;
    img.style.boxShadow = `0 0 10px 3px #${this.getAttribute("colors-3")}`;
    img.className = this.getAttribute("class");

    this.appendChild(img);
  }
}

window.customElements.define("moc-medal", MOCMedal);

// wordcloud
class MOCWordCloud extends HTMLElement {
  constructor() {
    super();

    const words = this.getAttribute("words");
    const colors = ["#143059", "#2F6B9A", "#82a6c2"];

    const div = document.createElement("div");
    div.style.width = this.getAttribute("width");
    div.style.height = this.getAttribute("height");
    this.appendChild(div);

    let list = words.split(",").map((item) => {
      const word = item.split("|")[0];
      const count = parseInt(item.split("|")[1]);
      return [word, count];
    });

    const width = div.getBoundingClientRect().width;
    const weight_sum = list.reduce((acc, item) => acc + item[1], 0);
    WordCloud(div, {
      list: list,
      weightFactor: (width * 2) / weight_sum,
      color: function (word, weight) {
        return colors[Math.floor(weight % colors.length)];
      },
      fontFamily: "M PLUS Code Latin",
      rotateRatio: 0.5,
      rotationSteps: 10,
      backgroundColor: "transparent",
      drawOutOfBound: false,
      shrinkToFit: true,
    });
  }
}

window.customElements.define("moc-wordcloud", MOCWordCloud);

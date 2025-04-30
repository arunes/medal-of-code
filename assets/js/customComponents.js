import { createAvatar } from "@dicebear/core";
import { shapes as medals, bottts as avatars } from "@dicebear/collection";
import CalHeatmap from "cal-heatmap";
import LegendLite from "cal-heatmap/plugins/LegendLite";
import Tooltip from "cal-heatmap/plugins/Tooltip";
import CalendarLabel from "cal-heatmap/plugins/CalendarLabel";

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

// Renders a github like contributions calendar
class MOCContributionCalendar extends HTMLElement {
  constructor() {
    super();

    const cal = new CalHeatmap();
    const id = this.getAttribute("id");
    const contributor_id = this.getAttribute("contributor_id");

    const div = document.createElement("div");
    div.className = this.getAttribute("class");
    this.appendChild(div);

    cal.paint(
      {
        theme: localStorage.theme,
        itemSelector: `#${id}`,
        date: { start: new Date("2024-06-01") },
        data: {
          source: `/api/contributors/${contributor_id}/activity`,
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

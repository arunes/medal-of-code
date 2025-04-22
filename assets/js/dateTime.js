// Converts UTC to local time
window.addEventListener("moc:to_local_time", (event) => {
  const formatter = new Intl.DateTimeFormat("en-US", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

  const elm = event.target;
  const utc = new Date(elm.innerText);
  elm.innerText = formatter.format(utc);
});

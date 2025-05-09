function darkExpected() {
  return (
    localStorage.theme === "dark" ||
    (!("theme" in localStorage) &&
      window.matchMedia("(prefers-color-scheme: dark)").matches)
  );
}

function initDarkMode() {
  if (darkExpected()) {
    document.documentElement.classList.add("dark");
  } else {
    document.documentElement.classList.remove("dark");
  }
}

window.addEventListener("toggle-darkmode", (_event) => {
  if (darkExpected()) {
    localStorage.theme = "light";
  } else {
    localStorage.theme = "dark";
  }
  initDarkMode();
});

window["isDarkMode"] = darkExpected();
initDarkMode();

function darkExpected() {
  console.log(localStorage.theme);
  return (
    localStorage.theme === "dark" ||
    (!("theme" in localStorage) &&
      window.matchMedia("(prefers-color-scheme: dark)").matches)
  );
}

function initDarkMode() {
  console.log("UUU2");
  if (darkExpected()) {
    document.documentElement.classList.add("dark");
  } else {
    document.documentElement.classList.remove("dark");
  }
}

window.addEventListener("toggle-darkmode", (_event) => {
  console.log("UUU");
  if (darkExpected()) {
    localStorage.theme = "light";
  } else {
    localStorage.theme = "dark";
  }
  initDarkMode();
});

initDarkMode();

function darkExpected() {
  console.log(localStorage.theme);
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

window.addEventListener("toogle-darkmode", (e) => {
  if (darkExpected()) localStorage.theme = "light";
  else localStorage.theme = "dark";
  initDarkMode();
});

initDarkMode();

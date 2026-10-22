// clean-landing-v1 — template interaction glue (nav toggle, form states, year)
(function () {
  "use strict";

  // mobile nav (component: nav collapses to hamburger)
  var toggle = document.getElementById("nav-toggle");
  var links = document.getElementById("nav-links");
  if (toggle && links) {
    toggle.addEventListener("click", function () {
      var open = links.classList.toggle("open");
      toggle.setAttribute("aria-expanded", open ? "true" : "false");
    });
    links.addEventListener("click", function (e) {
      if (e.target.closest("a")) {
        links.classList.remove("open");
        toggle.setAttribute("aria-expanded", "false");
      }
    });
  }

  // waitlist form: state_error / ok inline message (component spec)
  var form = document.getElementById("waitlist-form");
  var msg = document.getElementById("form-msg");
  if (form && msg) {
    form.addEventListener("submit", function (e) {
      e.preventDefault();
      var email = form.elements["email"];
      var value = (email.value || "").trim();
      var valid = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value);
      msg.classList.remove("error", "ok");
      if (!valid) {
        msg.textContent = "Please enter a valid work email.";
        msg.classList.add("error");
        email.focus();
        return;
      }
      msg.textContent = "Thanks — you're on the list! (demo: no data sent)";
      msg.classList.add("ok");
      form.reset();
    });
  }

  var year = document.getElementById("year");
  if (year) year.textContent = String(new Date().getFullYear());
})();
